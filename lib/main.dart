import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          'HUD': (context, game) => GameHUD(game: game),
          'LevelComplete': (context, game) => OverlayPanel(
              title: 'Galaxy Conquered',
              color: Colors.greenAccent,
              onPressed: () {
                game.overlays.remove('LevelComplete');
                game.nextLevel();
              },
              buttonText: 'Warp to Next Sector'),
          'Retry': (context, game) => OverlayPanel(
              title: 'Signal Lost',
              color: Colors.redAccent,
              onPressed: () {
                game.overlays.remove('Retry');
              },
              buttonText: 'Re-Initialize'),
        },
        initialActiveOverlays: const ['HUD'],
      ),
    );
  }
}

class GameHUD extends StatelessWidget {
  final CosmicWormholeGame game;
  const GameHUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Title
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                "Galaxy ${game.currentLevelIndex + 1}",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "ORBITAL",
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  color: Colors.orange,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
        
        // Bottom Stats Panel
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatItem(label: "TOTAL", value: "12"), // Placeholder for total score
                      const SizedBox(width: 20),
                      _StatItem(label: "AVG", value: "4.0"),
                       const SizedBox(width: 20),
                      // Since we can't easily listen to property changes without a ChangeNotifier,
                      // For a simple demo we can use a periodic ticker or StreamBuilder if the game exposed a stream.
                      // Or just let it update when state changes if passing a listenable.
                      // Here we will just display static or rebuild if parent rebuilds.
                      // For now, let's assume static or simple display for the prototype.
                       _StatItem(label: "SHOT", value: "${game.shotCount}"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Corner Buttons
        Positioned(
          top: 20,
          left: 20,
          child: _IconButton(icon: Icons.help_outline),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: _IconButton(icon: Icons.volume_up),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: _IconButton(icon: Icons.ac_unit), // Abstract icon
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label ",
          style: GoogleFonts.orbitron(
            fontSize: 10,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Icon(icon, color: Colors.grey, size: 20),
    );
  }
}

class OverlayPanel extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final String buttonText;

  const OverlayPanel({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
             decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    color: color,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: color, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color.withValues(alpha: 0.2),
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText, style: GoogleFonts.orbitron()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
