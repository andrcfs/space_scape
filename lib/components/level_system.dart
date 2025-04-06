import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/components/weapons/weapon_system.dart';

import '../space_game.dart';
import 'upgrade_level.dart';

class LevelSystem extends Component with HasGameReference<SpaceGame> {
  final WeaponSystem weaponSystem;
  int _playerLevel = 1;
  int _currentXP = 4;
  int _xpToNextLevel = 5;
  final double _xpGrowthRate = 1.2;

  // Flag to track if level up is pending
  bool _levelUpPending = false;

  // ValueNotifiers for UI updates
  final ValueNotifier<double> xpProgress = ValueNotifier(0.0);
  final ValueNotifier<int> level = ValueNotifier(1);

  LevelSystem(this.weaponSystem);

  int get playerLevel => _playerLevel;
  int get currentXP => _currentXP;
  int get xpToNextLevel => _xpToNextLevel;
  bool get levelUpPending => _levelUpPending;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  void addXP(int amount) {
    _currentXP += amount;

    // Check if player leveled up
    if (_currentXP >= _xpToNextLevel) {
      _playerLevel++;
      level.value = _playerLevel;
      _currentXP -= _xpToNextLevel;
      _xpToNextLevel = (_xpToNextLevel * _xpGrowthRate).toInt();

      // Set flag for level up: não sei se isso vai ser útil
      _levelUpPending = true;
      // Pause game and show upgrade menu
      game.pauseEngine();
      game.overlays.add('UpgradeMenu');
    }

    // Update XP progress
    xpProgress.value = _currentXP / _xpToNextLevel;
  }

  // Get available upgrades for the current level-up
  List<UpgradeLevel> getAvailableUpgrades() {
    //TODO: IMPLEMENTAR UPGRADES PASSIVOS
    List<UpgradeLevel> availableUpgrades = [];
    for (final weapon in weaponSystem.availableWeapons) {
      availableUpgrades.add(weapon.getNextUpgrade());
    }
    if (availableUpgrades.isEmpty) {
      // If no weapon upgrades available, offer repair
      availableUpgrades.add(UpgradeLevel(
        name: 'Repair',
        description: 'Recover health',
        level: 0,
        upgradeType: UpgradeType.passive,
        icon: '',
        statChanges: {'health': game.player.ship.maxHealth},
      ));
    }

    // Shuffle and take up to 3
    availableUpgrades.shuffle(Random());
    return availableUpgrades.take(min(3, availableUpgrades.length)).toList();
  }

  void applyUpgrade(UpgradeLevel upgrade) {
    //TODO: IMPLEMENTAR UPGRADES PASSIVOS e ativos
    if (upgrade.upgradeType == UpgradeType.weapon) {
      final weapon = weaponSystem.availableWeapons.firstWhere(
        (element) => element.name == upgrade.name,
        orElse: () => throw Exception('Weapon ${upgrade.name} not found!'),
      );
      if (upgrade.level == 0) {
        weaponSystem.addWeapon(weapon);
      } else if (upgrade.level < 7) {
        weapon.applyUpgrade(upgrade);
      }
      //Remove upgrade from the weapon's available upgrades
      weapon.removeUpgrade(upgrade);
    }
    if (upgrade.upgradeType == UpgradeType.passive) {
      if (upgrade.statChanges.containsKey('health')) {
        game.player.ship.health.value += upgrade.statChanges['health'];
        if (game.player.ship.health.value > game.player.ship.maxHealth) {
          game.player.ship.health.value = game.player.ship.maxHealth;
        }
      }
      if (upgrade.statChanges.containsKey('shield')) {
        game.player.ship.shield.value += upgrade.statChanges['shield'];
        if (game.player.ship.shield.value > game.player.ship.maxShield) {
          game.player.ship.shield.value = game.player.ship.maxShield;
        }
      }
      if (upgrade.statChanges.containsKey('maxHealth')) {
        game.player.ship.modifyMaxHealth(upgrade.statChanges['maxHealth']);
      }
    }

    // A ia adicionou isso e n sei se vai ser útil kkk
    _levelUpPending = false;
  }
}
