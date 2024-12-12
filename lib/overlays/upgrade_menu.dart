import 'package:flutter/material.dart';

import '../components/upgrade.dart';
import '../space_game.dart';

class UpgradeMenu extends StatelessWidget {
  final SpaceGame game;
  const UpgradeMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Upgrade> upgrades = game.player.levelSystem.getUpgradeOptions();
    if (upgrades.isEmpty) {
      upgrades = [
        Upgrade(
          name: 'Repair',
          type: UpgradeType.passive,
          levels: [
            UpgradeLevel(
              description: 'Recover health.',
              apply: (player) {
                player.health.value = player.maxHealth;
              },
            ),
          ],
        ),
      ];
    }
    upgrades.shuffle();
    upgrades = upgrades.take(3).toList();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose an Upgrade',
                style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 20),
            ...upgrades.map((upgrade) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8.0)),
                    onPressed: () =>
                        game.player.levelSystem.applyUpgrade(upgrade),
                    child: Text(
                      '${upgrade.name}: ${upgrade.getCurrentDescription()}, ${upgrade.currentLevel}',
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
