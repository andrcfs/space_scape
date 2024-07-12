import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/space_scape.dart';

class SpaceGameWidget extends StatelessWidget {
  const SpaceGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget<SpaceGame>(
        game: SpaceGame(),
        loadingBuilder: (context) => Center(
          child: Text(
            'Loading...',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
