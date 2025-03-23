import 'package:flutter/material.dart';

import '../components/upgrade.dart';
import '../space_game.dart';

class UpgradeMenu extends StatelessWidget {
  final SpaceGame game;
  const UpgradeMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    // Get available upgrades from the level system
    List<UpgradeLevel> availableUpgrades =
        game.levelSystem.getAvailableUpgrades();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black.withAlpha(204),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose an Upgrade',
                style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: availableUpgrades
                  .take(3) // Limit to 3 upgrades
                  .map((upgrade) => UpgradeOption(
                        upgrade: upgrade,
                        onSelected: () => _applyUpgrade(upgrade),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _applyUpgrade(UpgradeLevel upgrade) {
    // Use the level system to apply the upgrade
    game.levelSystem.applyUpgrade(upgrade);

    // Close the upgrade menu
    game.resumeEngine();
    game.overlays.remove('UpgradeMenu');
  }
}

class UpgradeOption extends StatelessWidget {
  final UpgradeLevel upgrade;
  final VoidCallback onSelected;

  const UpgradeOption({
    super.key,
    required this.upgrade,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 180,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.indigo.withAlpha(180),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blueAccent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(100),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Upgrade icon or placeholder
                const Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: Colors.yellow,
                ),

                // Upgrade name
                Text(
                  upgrade.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Upgrade description
                Text(
                  upgrade.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),

                // Stats change
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    upgrade.getStatsChangeDescription(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
