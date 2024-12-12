import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/maps/map1.dart';
import 'package:space_scape/overlays/hud.dart';
import 'package:space_scape/overlays/menu.dart';
import 'package:space_scape/overlays/pause_menu.dart';
import 'package:space_scape/overlays/upgrade_menu.dart';
import 'package:space_scape/space_game.dart';

class SpaceGameWidget extends StatelessWidget {
  const SpaceGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget<SpaceGame>(
        game: SpaceGame(world: Map1()),
        loadingBuilder: (context) => Center(
          child: Text(
            'Loading...',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        overlayBuilderMap: {
          'Menu': (_, game) => Menu(game),
          //'DeathScreen': (_, __) => DeathScreen(game),
          //'EndScreen': (_, __) => EndScreen(game),
          'PauseMenu': (_, game) => PauseMenu(game),
          'PlayerUI': (_, game) => HUD(game),
          'UpgradeMenu': (_, game) => UpgradeMenu(game),
          //'GameStats': (_, __) => GameStatsWidget(game),
        },
        initialActiveOverlays: const ['Menu'],
      ),
    );
  }
}
