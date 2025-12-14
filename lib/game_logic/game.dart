import 'dart:math';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wormhole/components/comet.dart';
import 'package:wormhole/components/obstacle.dart';
import 'package:wormhole/components/wormhole.dart';
import 'package:wormhole/game_logic/levels.dart';
import 'package:wormhole/bloc/game_bloc.dart';

class CosmicWormholeGame extends FlameGame with HasCollisionDetection, PanDetector {
  final GameBloc bloc;
  
  CosmicWormholeGame({required this.bloc});

  late Comet comet;
  late Wormhole wormhole;
  List<Obstacle> obstacles = [];
  
  // Visuals
  final Random _rng = Random();
  late List<Offset> _stars;
  late List<double> _starBrightness;
  
  int currentLevelIndex = 0;
  bool isDragging = false;
  Vector2? dragStart;
  Vector2? dragEnd;
  
  // Physics Constants
  static const double G = 25.0; // Gravitational constant

  @override
  Future<void> onLoad() async {
    _generateStars();
    loadLevel(currentLevelIndex);
  }

  void _generateStars() {
    _stars = List.generate(200, (index) {
      return Offset(
        _rng.nextDouble() * canvasSize.x,
        _rng.nextDouble() * canvasSize.y,
      );
    });
    _starBrightness = List.generate(200, (index) => _rng.nextDouble());
  }
  
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _generateStars();
  }

  void loadLevel(int index) {
    // Clear existing
    children.whereType<Comet>().forEach((e) => e.removeFromParent());
    children.whereType<Wormhole>().forEach((e) => e.removeFromParent());
    children.whereType<Obstacle>().forEach((e) => e.removeFromParent());
    obstacles.clear();

    if (index >= Levels.levels.length) {
      index = 0; // Loop back or show end screen handling
    }
    currentLevelIndex = index;
    final level = Levels.levels[index];

    // Setup World
    comet = Comet(position: level.startPosition);
    add(comet);

    wormhole = Wormhole(position: level.wormholePosition);
    add(wormhole);

    for (final obs in level.obstacles) {
      add(obs);
      obstacles.add(obs);
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (comet.isLaunched) return;
    isDragging = true;
    dragStart = info.eventPosition.global;
    dragEnd = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isDragging) return;
    dragEnd = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!isDragging) return;
    isDragging = false;
    
    // Slingshot logic
    if (dragStart != null && dragEnd != null) {
      final force = dragStart! - dragEnd!;
      if (force.length > 5) { // Minimum pull
        comet.velocity = force * 2.0; // Multiplier for power
        comet.isLaunched = true;
        bloc.add(ShotFired());
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (comet.isLaunched) {
      applyPhysics(dt);
      checkWinCondition();
    }
  }

  @override
  void render(Canvas canvas) {
    _renderBackground(canvas);
    super.render(canvas);
    if (isDragging && dragStart != null && dragEnd != null) {
      _drawTrajectory(canvas);
      _drawSlingshotLine(canvas);
    }
  }

  void _renderBackground(Canvas canvas) {
    final starPaint = Paint()..color = Colors.white;
    for (int i = 0; i < _stars.length; i++) {
        starPaint.color = Colors.white.withValues(alpha: _starBrightness[i] * 0.8);
        canvas.drawCircle(_stars[i], _starBrightness[i] * 1.5, starPaint);
    }
  }

  void _drawSlingshotLine(Canvas canvas) {
      final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2;
      canvas.drawLine(comet.position.toOffset(), (comet.position + (dragStart! - dragEnd!)).toOffset(), paint);
  }

  void _drawTrajectory(Canvas canvas) {
    // Prediction Physics
    Vector2 simPos = comet.position.clone();
    Vector2 simVel = (dragStart! - dragEnd!) * 2.0;
    
    final path = Path();
    path.moveTo(simPos.x, simPos.y);

    // Simulate 90 frames (1.5 seconds at 60fps)
    for (int i = 0; i < 90; i++) {
      double simDt = 0.016; // Fixed step
      
      // Calculate forces
      Vector2 totalForce = Vector2.zero();
      for (final obs in obstacles) {
        final direction = obs.position - simPos;
        final distance = direction.length;
        if (distance < obs.radius + 5) break; // Collision prediction approximate

        final forceMagnitude = (G * obs.mass) / (distance * distance);
        final forceDir = direction.normalized();
        
        if (obs.type == ObstacleType.gravity) {
          totalForce += forceDir * forceMagnitude;
        } else {
          totalForce -= forceDir * forceMagnitude;
        }
      }

      simVel += totalForce * simDt;
      simPos += simVel * simDt;
      path.lineTo(simPos.x, simPos.y);
    }

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw dashed path manually
    final metric = path.computeMetrics().first;
    double distance = 0.0;
    while (distance < metric.length) {
      final extractPath = metric.extractPath(distance, distance + 5.0);
      canvas.drawPath(extractPath, paint);
      distance += 10.0;
    }
  }

  void applyPhysics(double dt) {
    // Real Physics (Mirroring simulation)
    Vector2 totalForce = Vector2.zero();
      for (final obs in obstacles) {
        final direction = obs.position - comet.position;
        final distance = direction.length;
        
        // Simple gravity formulation: F = ma => a = F/m. Assuming comet mass = 1.
        // F = G*M*m/r^2. a = G*M/r^2.
        
        // Clamp min distance to avoid infinity
        final clampedDist = distance < 10 ? 10.0 : distance;

        final forceMagnitude = (G * obs.mass) / (clampedDist * clampedDist);
        final forceDir = direction.normalized();
        
        if (obs.type == ObstacleType.gravity) {
          totalForce += forceDir * forceMagnitude;
        } else {
          totalForce -= forceDir * forceMagnitude;
        }
      }
      
      comet.velocity += totalForce * dt;
      // Position interaction is handled by Comet's update method directly (pos += vel * dt) 
      // But we need to make sure we don't double update if I moved logic here.
      // Comet updates position in its own update(). We update velocity here.
  }
  
  void checkWinCondition() {
    // Check collision with Wormhole
    if (comet.position.distanceTo(wormhole.position) < wormhole.radius + comet.radius) {
      // WIN
      print("WIN!");
      comet.isLaunched = false;
      comet.velocity = Vector2.zero();
      bloc.add(LevelWon());
      overlays.add('LevelComplete');
    }

    // Check collision with Obstacles or Bounds
    for (final obs in obstacles) {
       if (comet.position.distanceTo(obs.position) < obs.radius + comet.radius) {
         // CRASH
         resetLevel();
         return;
       }
    }

    // Bounds check
    if (comet.position.x < -100 || comet.position.x > canvasSize.x + 100 ||
        comet.position.y < -100 || comet.position.y > canvasSize.y + 100) {
      resetLevel();
    }
  }

  void resetLevel() {
    print("LOST");
    bloc.add(LevelLost());
    comet.isLaunched = false;
    comet.velocity = Vector2.zero();
    comet.position = Levels.levels[currentLevelIndex].startPosition;
    overlays.add('Retry');
  }
  
  void nextLevel() {
    loadLevel(currentLevelIndex + 1);
  }
}
