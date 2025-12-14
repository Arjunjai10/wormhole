import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wormhole extends PositionComponent {
  final double radius;
  double _time = 0;

  Wormhole({
    required Vector2 position,
    this.radius = 40,
  }) : super(position: position, size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(radius, radius);
    
    // Pulsing effect
    final pulse = (1.0 + 0.1 * (1 + sin(2 * _time)) / 2);

    // Accretion Disk (Animated Sweep)
    // Rotate canvas for spin effect
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_time); 
    canvas.translate(-center.dx, -center.dy);

    final diskPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.purple, 
          Colors.deepPurple, 
          Colors.white, 
          Colors.deepPurple, 
          Colors.purple
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.0));
      
    // Draw disk with pulse
    final glowPaint = Paint()
      ..color = Colors.purpleAccent.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius * 1.5 * pulse, glowPaint);

    canvas.drawCircle(center, radius * 1.3, diskPaint);
    canvas.restore();

    // Event Horizon (Black Void) - Static relative to disk
    final holePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(center, radius * 0.8, holePaint);
    
    // Singularity Ring (Thin bright ring) with slight pulse
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * pulse;
      
    canvas.drawCircle(center, radius * 0.8, ringPaint);
  }
}
