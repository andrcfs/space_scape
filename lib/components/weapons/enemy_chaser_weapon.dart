import 'package:flame/components.dart';
import 'package:space_scape/components/enemy_chaser_missile.dart';
import 'package:space_scape/components/upgrade.dart';

import 'weapon.dart';

class EnemyChaserWeapon extends Weapon {
  double _damage = 5.0;
  double _cooldown = 4.0;
  double _missileSpeed = 140.0;
  double _turnRate = 3.0;

  EnemyChaserWeapon({
    required super.player,
    super.name = 'EnemyChaser',
    super.description = 'Fires twin homing missiles from the wings',
    super.iconPath = 'weapons/basic_shot.png',
    super.unlocked = true,
  }) : super(weaponId: 'enemy_chaser_weapon') {
    initUpgrades([
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Unlock EnemyChaser',
        level: 0,
        upgradeType: UpgradeType.weapon,
        statChanges: {},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Reduce cooldown by 10%',
        level: 1,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.9},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase missile speed by 15%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'missileSpeed': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase missile damage by 2',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 2.0},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Reduce cooldown by 10%',
        level: 4,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.9},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase turn rate by 20%',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'turnRate': 1.2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase missile speed by 15%',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'missileSpeed': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase missile damage by 2',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 2.0},
      ),
    ]);
  }

  @override
  double get damage => _damage;

  @override
  double get cooldown => _cooldown;

  @override
  double? get speed => _missileSpeed;

  @override
  void fire() {
    final forward = player.direction.normalized();
    final right = Vector2(-forward.y, forward.x);
    final wingOffset = player.ship.size.x * 0.45;
    final forwardOffset = player.ship.size.y * 0.1;

    final leftSpawn = player.ship.position +
        right.scaled(-wingOffset) +
        forward.scaled(forwardOffset);
    final rightSpawn = player.ship.position +
        right.scaled(wingOffset) +
        forward.scaled(forwardOffset);

    game.world.addAll([
      EnemyChaserMissile(
        position: leftSpawn,
        direction: forward,
        speed: _missileSpeed,
        damage: _damage,
        turnRate: _turnRate,
      ),
      EnemyChaserMissile(
        position: rightSpawn,
        direction: forward,
        speed: _missileSpeed,
        damage: _damage,
        turnRate: _turnRate,
      ),
    ]);
  }

  @override
  void upgradeStats(Map<String, dynamic> stats) {
    stats.forEach((key, value) {
      switch (key) {
        case 'damage':
          _damage += value as double;
          break;
        case 'cooldown':
          _cooldown *= value as double;
          break;
        case 'missileSpeed':
          _missileSpeed *= value as double;
          break;
        case 'turnRate':
          _turnRate *= value as double;
          break;
      }
    });
  }
}
