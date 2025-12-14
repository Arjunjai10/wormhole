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
    if (velocity.length > 5 && isMounted) {
     // Use parent to add particles so they don't move with the comet component
      parent?.add(ParticleSystemComponent(
        particle: Particle.generate(
          count: 5,
          lifespan: 0.6,
          generator: (i) {
            final rng = random;
            return AcceleratedParticle(
            acceleration: -velocity.normalized() * 10, // Slight drag
            speed: Vector2(rng.nextDouble() - 0.5, rng.nextDouble() - 0.5) * 20,
            position: position.clone() + Vector2(rng.nextDouble() - 0.5, rng.nextDouble() - 0.5) * 5,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()
                  ..color = Color.lerp(Colors.cyanAccent, Colors.purpleAccent, particle.progress)!
                      .withValues(alpha: (1 - particle.progress) * 0.6)
                  ..style = PaintingStyle.fill;
                  
                canvas.drawCircle(Offset.zero, (1 - particle.progress) * 4, paint);
              }
            ),
          );
          },
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
