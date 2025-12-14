import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ObstacleType { gravity, antigravity }

class Obstacle extends PositionComponent {
  final double radius;
  final double mass;
  final ObstacleType type;

  Obstacle({
    required Vector2 position,
    required this.radius,
    required this.mass,
    required this.type,
  }) : super(position: position, size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius));
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = type == ObstacleType.gravity ? Colors.cyan : Colors.deepOrange
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10); // Neon glow

    canvas.drawCircle(Offset(radius, radius), radius, paint);
    
    // Core
    final corePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius * 0.3, corePaint);
  }
}
