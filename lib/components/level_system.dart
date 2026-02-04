import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/components/upgrades/upgrade.dart';
import 'package:space_scape/components/upgrades/upgrade_manager.dart';

import '../space_game.dart';

class LevelSystem extends Component with HasGameReference<SpaceGame> {
  final UpgradeManager upgradeManager;
  int _playerLevel = 1;
  int _currentXP = 4;
  int _xpToNextLevel = 5;
  final double _xpGrowthRate = 1.2;

  // Flag to track if level up is pending
  bool _levelUpPending = false;

  // ValueNotifiers for UI updates
  final ValueNotifier<double> xpProgress = ValueNotifier(0.0);
  final ValueNotifier<int> level = ValueNotifier(1);

  LevelSystem(this.upgradeManager);

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

  List<Upgrade> getAvailableUpgrades() {
    final availableUpgrades = upgradeManager.getAvailableUpgrades(playerLevel);

    // Shuffle and take up to 3
    availableUpgrades.shuffle(Random());
    return availableUpgrades.take(min(3, availableUpgrades.length)).toList();
  }

  void applyUpgrade(Upgrade upgrade) {
    upgrade.apply(game);
    _levelUpPending = false;
  }
}