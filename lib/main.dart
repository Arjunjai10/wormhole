import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MaterialApp(
    home: GameScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget<CosmicWormholeGame>.controlled(
        gameFactory: CosmicWormholeGame.new,
        overlayBuilderMap: {
          'LevelComplete': (context, game) => Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Level Complete!',
                          style: TextStyle(color: Colors.green, fontSize: 30)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          game.overlays.remove('LevelComplete');
                          game.nextLevel();
                        },
                        child: const Text('Next Level'),
                      ),
                    ],
                  ),
                ),
              ),
          'Retry': (context, game) => Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Crashed!',
                          style: TextStyle(color: Colors.red, fontSize: 30)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          game.overlays.remove('Retry');
                          // Already reset in logic, just hiding overlay essentially
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
        },
      ),
    );
  }
}
