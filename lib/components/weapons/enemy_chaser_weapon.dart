import 'package:flame/components.dart';
import 'package:space_scape/components/enemy_chaser_missile.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/components/upgrades/upgrade.dart';

import 'weapon.dart';

class EnemyChaserWeapon extends Weapon {
  double _damage = 5.0;
  double _cooldown = 4.0;
  double _missileSpeed = 140.0;
  double _turnRate = 3.0;
  static const String _overlaySpritePath = 'player_enemychaser.png';

  SpriteComponent? _overlay;

  EnemyChaserWeapon({
    required Player player,
    String name = 'EnemyChaser',
    String description = 'Fires twin homing missiles from the wings',
    String iconPath = 'weapons/basic_shot.png',
    bool unlocked = true,
  }) : super(
          player: player,
          name: name,
          description: description,
          iconPath: iconPath,
          pushForce: 0.0,
          unlocked: unlocked,
        ) {
    initUpgrades([
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Unlock EnemyChaser',
        level: 0,
        statChanges: {},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Reduce cooldown by 10%',
        level: 1,
        statChanges: {'cooldown': 0.9},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Increase missile speed by 15%',
        level: 2,
        statChanges: {'missileSpeed': 1.15},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Increase missile damage by 2',
        level: 3,
        statChanges: {'damage': 2.0},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Reduce cooldown by 10%',
        level: 4,
        statChanges: {'cooldown': 0.9},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Increase turn rate by 20%',
        level: 5,
        statChanges: {'turnRate': 1.2},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Increase missile speed by 15%',
        level: 6,
        statChanges: {'missileSpeed': 1.15},
      ),
      WeaponUpgrade(
        name: name,
        icon: iconPath,
        description: 'Increase missile damage by 2',
        level: 7,
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
  Future<void> onLoad() async {
    await super.onLoad();
    if (_overlay != null) return;

    final sprite = await game.loadSprite(_overlaySpritePath);

    _overlay = SpriteComponent(
      sprite: sprite,
      position: player.ship.position,
      size: Vector2(36, 39),
      anchor: Anchor.center,
      priority: 1,
    );

    game.world.add(_overlay!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_overlay != null) {
      _overlay!.position = player.ship.position;
      _overlay!.angle = player.ship.angle;
    }
  }

  @override
  void fire() {
    final forward = player.direction.normalized();
    final leftSpawn = _getWingSpawnPosition(Vector2(5, 16));
    final rightSpawn = _getWingSpawnPosition(Vector2(30, 16));

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

  Vector2 _getWingSpawnPosition(Vector2 pixelPosition) {
    final center = player.ship.size * 0.5;
    final localOffset = pixelPosition - center;
    final rotatedOffset = localOffset.clone()..rotate(player.ship.angle);
    return player.ship.position + rotatedOffset;
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
