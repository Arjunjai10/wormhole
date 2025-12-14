import 'package:flame/components.dart';
import 'package:wormhole/components/obstacle.dart';

class LevelData {
  final Vector2 startPosition;
  final Vector2 wormholePosition;
  final List<Obstacle> obstacles;
  final String hint;

  LevelData({
    required this.startPosition,
    required this.wormholePosition,
    required this.obstacles,
    this.hint = "Good luck!",
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
      hint: "Let gravity assist you. Aim slightly above the planet to curve into the goal.",
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
      hint: "Avoid the orange repulsor! Use the blue planet's gravity to pull you back on track.",
    ),
    // Level 3: Gravity Gate (The Squeeze)
    LevelData(
        startPosition: Vector2(100, 300),
        wormholePosition: Vector2(750, 300),
        obstacles: [
          Obstacle(
            position: Vector2(400, 150),
            radius: 45,
            mass: 60000,
            type: ObstacleType.gravity,
          ),
          Obstacle(
            position: Vector2(400, 450),
            radius: 45,
            mass: 60000,
            type: ObstacleType.gravity,
          ),
        ],
        hint: "Thread the needle! Aim straight down the middle, but account for the dual pull.",
    ),
    // Level 4: Repulsor Field (Precision)
    LevelData(
        startPosition: Vector2(50, 200),
        wormholePosition: Vector2(750, 400),
        obstacles: [
          Obstacle(
            position: Vector2(300, 200),
            radius: 25,
            mass: 30000,
            type: ObstacleType.antigravity,
          ),
          Obstacle(
            position: Vector2(500, 100),
            radius: 30,
            mass: 35000,
            type: ObstacleType.antigravity,
          ),
           Obstacle(
            position: Vector2(400, 500),
            radius: 40,
            mass: 50000,
            type: ObstacleType.gravity,
          ),
        ],
        hint: "Weave between the repulsors or use the gravity planet below for a wide arc.",
    ),
    // Level 5: The Orbital Slingshot (Requires curving behind)
    LevelData(
        startPosition: Vector2(100, 500),
        wormholePosition: Vector2(700, 100),
        obstacles: [
           Obstacle(
            position: Vector2(400, 300),
            radius: 60,
            mass: 120000, // Massive sun
            type: ObstacleType.gravity,
          ),
          Obstacle(
            position: Vector2(650, 250),
            radius: 20,
            mass: 20000,
            type: ObstacleType.antigravity, // Blocker
          ),
        ],
        hint: "That sun is massive! Use its strong gravity to sling you around the back.",
    ),
    // Level 6: The Gauntlet (Zig Zag) - Nerfed
    LevelData(
        startPosition: Vector2(50, 500),
        wormholePosition: Vector2(750, 100),
        obstacles: [
          Obstacle(position: Vector2(250, 400), radius: 30, mass: 25000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(400, 200), radius: 30, mass: 25000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(550, 400), radius: 30, mass: 25000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(400, 500), radius: 50, mass: 90000, type: ObstacleType.gravity), // Stronger Helper
        ],
        hint: "Don't fight the repulsors directly. Use the big gravity planet to power through!",
    ),
    // Level 7: Binary System (Figure 8?)
    LevelData(
        startPosition: Vector2(50, 300),
        wormholePosition: Vector2(750, 300),
        obstacles: [
          Obstacle(position: Vector2(300, 200), radius: 55, mass: 90000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(500, 400), radius: 55, mass: 90000, type: ObstacleType.gravity),
        ],
        hint: "A figure-8 path might be the key here. Use the first planet to slingshot to the second.",
    ),
    // Level 8: Asteroid Field (Chaotic weak gravity)
    LevelData(
        startPosition: Vector2(50, 50),
        wormholePosition: Vector2(750, 550),
        obstacles: [
          Obstacle(position: Vector2(200, 200), radius: 20, mass: 20000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(300, 400), radius: 25, mass: 25000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(500, 250), radius: 20, mass: 20000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(600, 450), radius: 30, mass: 30000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(400, 300), radius: 20, mass: -20000, type: ObstacleType.antigravity), // Surprise push
        ],
        hint: "Chaos! Look for the repulsor in the middle—it might give you a needed push.",
    ),
     // Level 9: The Wall (Blocked Path)
    LevelData(
        startPosition: Vector2(100, 300),
        wormholePosition: Vector2(700, 300),
        obstacles: [
          // The Wall
          Obstacle(position: Vector2(400, 200), radius: 30, mass: 40000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(400, 300), radius: 30, mass: 40000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(400, 400), radius: 30, mass: 40000, type: ObstacleType.antigravity),
          // Helper to curve around
          Obstacle(position: Vector2(400, 550), radius: 60, mass: 100000, type: ObstacleType.gravity),
        ],
        hint: "You can't go through the wall. Go waaay around using the gravity planet at the bottom.",
    ),
     // Level 10: Grand Finale
    LevelData(
        startPosition: Vector2(50, 550),
        wormholePosition: Vector2(750, 50),
        obstacles: [
          Obstacle(position: Vector2(400, 300), radius: 80, mass: 150000, type: ObstacleType.gravity), // Core
          Obstacle(position: Vector2(200, 400), radius: 30, mass: 30000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(600, 200), radius: 30, mass: 30000, type: ObstacleType.antigravity),
          Obstacle(position: Vector2(700, 500), radius: 40, mass: 50000, type: ObstacleType.gravity),
          Obstacle(position: Vector2(100, 100), radius: 40, mass: 50000, type: ObstacleType.gravity),
        ],
        hint: "The final challenge. Use the central massive planet for a deep slingshot, but watch your exit vector!",
    ),
  ];
}
