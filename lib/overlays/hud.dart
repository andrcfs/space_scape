import 'package:flutter/material.dart';
import 'package:space_scape/space_game.dart';

class HUD extends StatelessWidget {
  final SpaceGame game;
  const HUD(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128), // 0.5 * 255 = 128
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              if (game.player.ship.maxShield > 0)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return ValueListenableBuilder(
                      valueListenable: game.player.ship.shield,
                      builder: (context, value, child) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          width: value /
                              game.player.ship.maxShield *
                              constraints.maxWidth,
                        );
                      },
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: game.player.ship.health,
                  builder: (context, health, child) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(204), // 0.8 * 255 = 204
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width:
                              (200 - 16) * health / game.player.ship.maxHealth,
                        ),
                        Center(
                          child: Text(
                            '${health.toInt()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white
                                  .withAlpha(204), // 0.8 * 255 = 204
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
