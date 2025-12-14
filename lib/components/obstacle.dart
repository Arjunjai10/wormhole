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
    _renderOrbitalRings(canvas);
    _renderPlanet(canvas);
  }

  void _renderOrbitalRings(Canvas canvas) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.1);

    // Draw a few concentric rings
    canvas.drawCircle(Offset(radius, radius), radius * 1.5, ringPaint);
    canvas.drawCircle(Offset(radius, radius), radius * 2.2, ringPaint);
    canvas.drawCircle(Offset(radius, radius), radius * 3.0, ringPaint);
  }

  void _renderPlanet(Canvas canvas) {
    // Gradient definitions
    final center = Offset(radius, radius);
    final colors = type == ObstacleType.gravity
        ? [Colors.cyan.shade300, Colors.blue.shade900]
        : [Colors.orange.shade300, Colors.red.shade900];
    
    final gradient = RadialGradient(
      colors: colors,
      stops: const [0.2, 1.0],
      center: const Alignment(-0.3, -0.3), // Light source offset
      radius: 1.2,
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    final paint = Paint()..shader = gradient;

    // Glow Effect
    final glowPaint = Paint()
      ..color = colors.first.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius, glowPaint);

    // Main Planet Body
    canvas.drawCircle(center, radius, paint);

    // Add Texture Details (Bands/Craters)
    final detailPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    if (type == ObstacleType.gravity) {
        // Craters for gravity planets
        canvas.drawCircle(center + Offset(-radius * 0.4, -radius * 0.2), radius * 0.15, detailPaint);
        canvas.drawCircle(center + Offset(radius * 0.3, radius * 0.5), radius * 0.2, detailPaint);
        canvas.drawCircle(center + Offset(radius * 0.6, -radius * 0.1), radius * 0.1, detailPaint);
    } else {
        // Bands for antigravity
        final bandPaint = Paint()
            ..color = Colors.black.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.2
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
            
        canvas.drawLine(
            Offset(0, radius * 0.7),
            Offset(radius * 2, radius * 0.7),
            bandPaint
        );
         canvas.drawLine(
            Offset(0, radius * 1.3),
            Offset(radius * 2, radius * 1.3),
            bandPaint
        );
    }
  }
}
