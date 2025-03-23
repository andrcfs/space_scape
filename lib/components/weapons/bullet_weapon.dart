import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/components/upgrade.dart';

import 'weapon.dart';

class BulletWeapon extends Weapon {
  // Bullet specific properties
  double _bulletSpeed = 200;
  final List<double> _bulletAngles = [0.0];
  int _bulletPenetration = 1;
  double _damage = 10;
  double _cooldown = 1.0;

  // Implement abstract getters
  @override
  double get damage => _damage;

  @override
  double get cooldown => _cooldown;

  @override
  double? get speed => _bulletSpeed;

  BulletWeapon({
    required super.player,
    super.name = 'Basic Shot',
    super.description = 'Fires bullets in the direction you\'re facing',
    super.iconPath = 'weapons/basic_shot.png',
    super.unlocked = true,
  }) : super(weaponId: 'bullet_weapon') {
    // Initialize all possible upgrades for this weapon
    initUpgrades([
      // Level 0 for unlocking the weapon
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'A basic weapon that shoots bullets',
        level: 0,
        upgradeType: UpgradeType.weapon,
        statChanges: {},
      ),
      // Level 1 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Reduce weapon cooldown by 15%',
        level: 1,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.85},
      ),

      // Level 2 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase bullet damage by 5',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 5.0},
      ),

      // Level 3 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Reduce weapon cooldown by 15%',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.85},
      ),

      // Level 4 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Bullets penetrate enemies once',
        level: 4,
        upgradeType: UpgradeType.weapon,
        statChanges: {'penetration': 1},
      ),

      // Level 5 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase bullet speed',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'bulletSpeed': 1.5},
      ),

      // Level 6 upgrade
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase bullet damage by 10 and attack speed',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 10.0, 'cooldown': 0.85},
      ),

      // Level 7 upgrade (final)
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Fire four bullets in a spread pattern',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {
          'bulletAngles': [-0.2, -0.07, 0.07, 0.2]
        },
      ),
    ]);
  }

  @override
  void fire() {
    game.world.addAll(
      _bulletAngles.map(
        (angle) => Bullet(
          position: player.ship.position +
              player.direction.scaled(player.ship.size.y / 2),
          speed: _bulletSpeed,
          angle: player.ship.angle + angle,
          damage: damage,
          penetration: _bulletPenetration,
        ),
      ),
    );
  }

  // Implement the abstract upgradeStats method
  @override
  void upgradeStats(Map<String, dynamic> stats) {
    stats.forEach((key, value) {
      switch (key) {
        case 'damage':
          _damage += value;
          break;
        case 'cooldown':
          _cooldown *= value; // Value like 0.85 for 15% reduction
          break;
        case 'bulletSpeed':
          _bulletSpeed *= value;
          break;
        case 'bulletAngles':
          _bulletAngles.add(value as double);
          break;
        case 'penetration':
          _bulletPenetration += value as int;
          break;
      }
    });
  }
}
