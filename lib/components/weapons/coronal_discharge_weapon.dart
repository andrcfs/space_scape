import 'package:space_scape/components/upgrade_level.dart';

import 'coronal_discharge_body.dart';
import 'weapon.dart';

class CoronalDischargeWeapon extends Weapon {
  // Area specific properties
  double _aoeRadius = 200.0;
  double _damage = 1;
  double _cooldown = 0.8;

  // Visual effect component
  late CoronalDischargeBody _coronalBody;

  // Implement abstract getters
  @override
  double get damage => _damage;

  @override
  double get cooldown => _cooldown;

  @override
  double? get range => _aoeRadius;

  CoronalDischargeWeapon({
    required super.player,
    super.name = 'Coronal Discharge',
    super.description =
        'Creates a high voltage eletric field that discharges at nearby enemies',
    super.iconPath = '',
    super.pushForce = 1,
    super.unlocked = true,
  }) {
    // Initialize all possible upgrades for this weapon
    initUpgrades([
      // Level 0 for unlocking the weapon
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: description,
        level: 0,
        upgradeType: UpgradeType.weapon,
        statChanges: {},
      ),
      // Level 1 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage by 2',
        level: 1,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 2.0},
      ),
      // Level 2 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase area size by 20%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'radius': 1.2},
      ),
      // Level 3 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage frequency by 15%',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.85},
      ),
      // Level 4 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage by 3',
        level: 4,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 3.0},
      ),
      // Level 5 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase area size by 30%',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'radius': 1.3},
      ),
      // Level 6 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage frequency by 20%',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.8},
      ),
      // Level 7 upgrade (final)
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Double damage and increase area by 20%',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 5.0, 'radius': 1.2},
      ),
    ]);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create the coronal discharge body component
    _coronalBody = CoronalDischargeBody(
      position: game.player.ship.size / 2, // Don't set player position here
      radius: _aoeRadius,
      damage: _damage,
      pushForce: pushForce,
    );

    add(_coronalBody);
  }

  // No need to modify position in update, as the component hierarchy will handle it
  // Since the weapon is a child of the ship, and the body is a child of the weapon

  @override
  void fire() {
    _coronalBody.applyDamage();
  }

  // Implement the abstract upgradeStats method
  @override
  void upgradeStats(Map<String, dynamic> stats) {
    stats.forEach(
      (key, value) {
        switch (key) {
          case 'damage':
            _damage += value;
            _coronalBody.damage = _damage;
            break;
          case 'cooldown':
            _cooldown *= value; // Value like 0.85 for 15% reduction
            break;
          case 'radius':
            _aoeRadius *= value; // Value like 1.2 for 20% increase
            _updateVisualRadius();
            break;
        }
      },
    );
  }

  void _updateVisualRadius() {
    // Update the visual indicator when radius changes
    _coronalBody.updateRadius(_aoeRadius);
  }
}
