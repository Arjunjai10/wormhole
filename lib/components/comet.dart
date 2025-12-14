import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Comet extends PositionComponent with CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final double radius = 10;
  bool isLaunched = false;
  final Random random = Random();

  Comet({required Vector2 position})
      : super(position: position, size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLaunched) return;

    position += velocity * dt;

    // Trail effect
    if (velocity.length > 5) {
      add(ParticleSystemComponent(
        particle: Particle.generate(
          count: 2,
          lifespan: 0.5,
          generator: (i) => AcceleratedParticle(
            acceleration: -velocity.normalized() * 50,
            speed: Vector2.random(random) * 20,
            position: position.clone(),
            child: CircleParticle(
              radius: 2,
              paint: Paint()..color = Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ));
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }
}
