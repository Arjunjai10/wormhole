import 'package:flame/components.dart';
import 'components/obstacle.dart';

class LevelData {
  final Vector2 startPosition;
  final Vector2 wormholePosition;
  final List<Obstacle> obstacles;

  LevelData({
    required this.startPosition,
    required this.wormholePosition,
    required this.obstacles,
  });
}

class Levels {
  static List<LevelData> levels = [
    // Level 1: Simple straight shot with one attractor
    LevelData(
      startPosition: Vector2(100, 300),
      wormholePosition: Vector2(700, 300),
      obstacles: [
        Obstacle(
          position: Vector2(400, 450),
          radius: 40,
          mass: 50000,
          type: ObstacleType.gravity,
        ),
      ],
    ),
    // Level 2: Repulsor in the middle
    LevelData(
      startPosition: Vector2(100, 300),
      wormholePosition: Vector2(700, 100),
      obstacles: [
        Obstacle(
          position: Vector2(400, 300),
          radius: 30,
          mass: 40000,
          type: ObstacleType.antigravity,
        ),
         Obstacle(
          position: Vector2(600, 500),
          radius: 50,
          mass: 80000,
          type: ObstacleType.gravity,
        ),
      ],
    ),
  ];
}
