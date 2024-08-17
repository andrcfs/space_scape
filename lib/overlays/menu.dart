import 'package:flutter/material.dart' hide Action;
import 'package:space_scape/space_game.dart';

class Menu extends StatelessWidget {
  final SpaceGame game;
  const Menu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilledButton(
                onPressed: () {
                  game.gameOver = false;
                  game.gameStart();
                  game.overlays.remove('Menu');
                },
                child: const Text('Start Game')),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {},
              child: const Text('Options'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                game.paused = false;
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
