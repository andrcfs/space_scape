import 'package:flutter/material.dart' hide Action;
import 'package:space_scape/space_game.dart';

class Menu extends StatelessWidget {
  final SpaceGame game;
  const Menu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF000428), Color(0xFF004e92)],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[400]!, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SPACE SCAPE',
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.blue,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuButton('START GAME', () {
                game.gameOver = false;
                game.startGame();
                game.overlays.remove('Menu');
              }),
              const SizedBox(height: 16),
              _buildMenuButton('TEST MODE', () {
                game.gameOver = false;
                game.startTest();
                game.overlays.remove('Menu');
              }),
              const SizedBox(height: 16),
              _buildMenuButton('OPTIONS', () {}),
              const SizedBox(height: 16),
              _buildMenuButton('EXIT', () {
                game.paused = false;
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.blue, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
