import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wormhole extends PositionComponent {
  final double radius;

  Wormhole({
    required Vector2 position,
    this.radius = 40,
  }) : super(position: position, size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius));
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(radius, radius);

    // Accretion Disk (Outer Glow)
    final diskPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, Colors.purpleAccent, Colors.transparent],
        stops: const [0.5, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(center, radius * 1.5, diskPaint);

    // Event Horizon (Black Void)
    final holePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2); // Slight edge blur

    canvas.drawCircle(center, radius * 0.8, holePaint);
    
    // Singularity Ring (Thin bright ring)
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
   canvas.drawCircle(center, radius * 0.8, ringPaint);
  }
}
