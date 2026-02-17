
import 'package:space_scape/components/upgrades/passive_upgrades.dart';
import 'package:space_scape/components/upgrades/upgrade.dart';
import 'package:space_scape/components/weapons/weapon_system.dart';

import '../../space_game.dart';

class UpgradeManager {
  final SpaceGame game;
  final WeaponSystem weaponSystem;

  UpgradeManager({required this.game, required this.weaponSystem});

  List<Upgrade> getAvailableUpgrades(int playerLevel) {
    List<Upgrade> availableUpgrades = [];

    // Add weapon upgrades
    for (final weapon in weaponSystem.availableWeapons) {
      availableUpgrades.add(weapon.getNextUpgrade());
    }

    // Add passive upgrades
    availableUpgrades.addAll(passiveUpgrades.where((upgrade) => upgrade.level == 1));

    // If no other upgrades are available, offer repair
    if (availableUpgrades.isEmpty) {
      availableUpgrades.add(RepairUpgrade(
        name: 'Repair',
        description: 'Recover health',
        icon: '',
        statChanges: {'health': game.player.ship.maxHealth},
      ));
    }

    return availableUpgrades;
  }
}
