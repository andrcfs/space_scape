import 'package:flame/components.dart';

import 'player.dart';
import 'upgrade.dart';

class LevelSystem extends Component with HasGameReference {
  final PlayerShip player;
  int _currentLevel = 1;
  int _currentXP = 0;
  int _xpToNextLevel = 10;
  double xpRating = 1.2;
  List<Upgrade> availableUpgrades = [];

  LevelSystem(this.player) {
    _initializeUpgrades();
  }

  int get currentLevel => _currentLevel;
  int get currentXP => _currentXP;
  int get xpToNextLevel => _xpToNextLevel;

  void _initializeUpgrades() {
    availableUpgrades = upgradesList;
  }

  void addXP(int amount) {
    _currentXP += amount;
    if (_currentXP >= _xpToNextLevel) levelUp();
  }

  void levelUp() {
    _currentXP -= _xpToNextLevel;
    _currentLevel++;
    _xpToNextLevel = calculateNextLevelXP();

    print('Leveled up to $_currentLevel!');
    showUpgradesMenu();
  }

  int calculateNextLevelXP() {
    return (_xpToNextLevel * xpRating).round();
  }

  void showUpgradesMenu() {
    game.overlays.add('UpgradeMenu');
    game.paused = true;
    print('Choose an upgrade:');
  }

  List<Upgrade> getUpgradeOptions() {
    List<Upgrade> options =
        availableUpgrades.where((upgrade) => !upgrade.isMaxLevel).toList();
    options.shuffle();
    return options.take(3).toList();
  }

  void applyUpgrade(Upgrade upgrade) {
    upgrade.apply(player);
    game.overlays.remove('UpgradeMenu');
    game.paused = false;
    print(
        'Applied upgrade: ${upgrade.name} - ${upgrade.getCurrentDescription()}');
  }
}
