
import 'package:space_scape/components/upgrades/passive_upgrades.dart';
import 'package:space_scape/components/upgrades/upgrade.dart';
import 'package:space_scape/components/weapons/weapon_system.dart';

import '../../space_game.dart';

class UpgradeManager {
  final SpaceGame game;
  final WeaponSystem weaponSystem;
  final Map<String, int> _passiveLevels = {};

  UpgradeManager({required this.game, required this.weaponSystem});

  List<Upgrade> getAvailableUpgrades(int playerLevel) {
    List<Upgrade> availableUpgrades = [];

    // Add weapon upgrades
    for (final weapon in weaponSystem.availableWeapons) {
      availableUpgrades.add(weapon.getNextUpgrade());
    }

    // Add passive upgrades
    final passiveNames = passiveUpgrades.map((upgrade) => upgrade.name).toSet();
    for (final name in passiveNames) {
      final currentLevel = _passiveLevels[name] ?? 0;
      for (final upgrade in passiveUpgrades) {
        if (upgrade.name == name && upgrade.level == currentLevel + 1) {
          availableUpgrades.add(upgrade);
          break;
        }
      }
    }

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

  void markApplied(Upgrade upgrade) {
    if (upgrade.upgradeType == UpgradeType.passive) {
      _passiveLevels[upgrade.name] = upgrade.level;
    }
  }
}
