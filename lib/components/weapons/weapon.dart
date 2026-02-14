// weapons/base_weapon.dart
import 'package:flame/components.dart';
import 'package:space_scape/components/entities/player.dart';
import 'package:space_scape/components/upgrades/upgrade.dart';
import 'package:space_scape/space_game.dart';

abstract class Weapon extends Component with HasGameReference<SpaceGame> {
  final Player player;

  // Common weapon properties
  final String _name;
  final String _description;
  final String _iconPath;
  int _level = -1;
  bool _enabled = true; //Just for test mode
  bool _unlocked =
      true; //TODO: Change to false once this feature is implemented
  double _cooldownTimer = 0;
  final double _pushForce;

  // List of all possible upgrades for this weapon
  final List<Upgrade> _upgradeList = [];

  // Getters for common properties
  String get name => _name;
  String get description => _description;
  String get iconPath => _iconPath;
  int get level => _level;
  bool get enabled => _enabled;
  bool get unlocked => _unlocked;
  double get pushForce => _pushForce;

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
    required double pushForce,
    bool unlocked = false,
  })  : _name = name,
        _description = description,
        _iconPath = iconPath,
        _pushForce = pushForce,
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

  void levelUp() {
    _level++;
  }

  // Apply upgrade to weapon and level up. Called from LevelSystem
  void applyUpgrade(Upgrade upgrade) {
    upgradeStats(upgrade.statChanges);
    levelUp();
  }

  // Initialize the possible upgrades for this weapon
  void initUpgrades(List<Upgrade> upgrades) {
    _upgradeList.addAll(upgrades);
  }

  Upgrade getActivateUpgrade() {
    return _upgradeList.firstWhere((upgrade) => upgrade.level == 0);
  }

  // Get available upgrades for this weapon at current level
  Upgrade getNextUpgrade() {
    return _upgradeList.firstWhere((upgrade) => upgrade.level == _level + 1);
  }

  void removeUpgrade(Upgrade upgrade) {
    _upgradeList.remove(upgrade);
  }

  // Abstract method for applying stats - to be implemented by subclasses
  void upgradeStats(Map<String, dynamic> stats);
}
