// weapons/base_weapon.dart
import 'package:flame/components.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/components/upgrade.dart';
import 'package:space_scape/space_game.dart';

abstract class Weapon extends Component with HasGameReference<SpaceGame> {
  final Player player;

  // Common weapon properties
  final String _name;
  final String _description;
  final String _iconPath;
  int _level = 0;
  bool _enabled = true; //Just for test mode
  bool _unlocked =
      true; //TODO: Change to false once this feature is implemented
  double _cooldownTimer = 0;

  // Each weapon needs an ID for upgrade mapping
  final String weaponId;

  // List of all possible upgrades for this weapon
  final List<UpgradeLevel> _upgradeList = [];

  // Getters for common properties
  String get name => _name;
  String get description => _description;
  String get iconPath => _iconPath;
  int get level => _level;
  bool get enabled => _enabled;
  bool get unlocked => _unlocked;

  // Abstract getters for stats that should be implemented by subclasses
  double get damage;
  double get cooldown;
  double? get size => null;
  double? get range => null;
  double? get speed => null;

  Weapon({
    required this.player,
    required String name,
    required String description,
    required String iconPath,
    required this.weaponId,
    bool unlocked = false,
  })  : _name = name,
        _description = description,
        _iconPath = iconPath,
        _unlocked = unlocked;

  @override
  void update(double dt) {
    super.update(dt);
    if (_cooldownTimer > 0) {
      _cooldownTimer -= dt;
    } else if (_enabled) {
      fire();
      _cooldownTimer = cooldown;
    }
  }

  // Abstract method to be implemented by specific weapons
  void fire();

  // Enable/disable weapon for testing purposes
  void setEnabled(bool isEnabled) {
    _enabled = isEnabled;
  }

  void unlock() {
    _unlocked = true; //TODO: This should be linked to game progress
  }

  // Apply upgrade to weapon and level up. Called from LevelSystem
  void applyUpgrade(UpgradeLevel upgradeLevel) {
    upgradeStats(upgradeLevel.statChanges);
    _level++;
  }

  // Initialize the possible upgrades for this weapon
  void initUpgrades(List<UpgradeLevel> upgrades) {
    _upgradeList.addAll(upgrades);
  }

  UpgradeLevel getActivateUpgrade() {
    return _upgradeList.firstWhere((upgrade) => upgrade.level == 0);
  }

  // Get available upgrades for this weapon at current level
  UpgradeLevel getNextUpgrade() {
    return _upgradeList.firstWhere((upgrade) => upgrade.level == _level + 1);
  }

  // Abstract method for applying stats - to be implemented by subclasses
  void upgradeStats(Map<String, dynamic> stats);
}
