import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_scape/components/flares.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/components/upgrade.dart';
import 'package:space_scape/space_game.dart';

import 'weapon.dart';

class FlaresWeapon extends Weapon {
  double _damage = 3.0;
  double _cooldown = 4.0;
  double _flareSpeed = 70.0;
  int _flareCount = 5;
  final double _flareInterval = 0.5;

  FlaresWeapon({
    required super.player,
    super.name = 'Flares',
    super.description = 'Launches wandering flares in chaotic paths',
    super.iconPath = 'weapons/basic_shot.png',
    super.unlocked = true,
  }) : super(weaponId: 'flares_weapon') {
    initUpgrades([
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Unlock flares',
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
        description: 'Increase flare speed by 15%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'flareSpeed': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase flare damage by 1',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 1.0},
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
        description: 'Increase flare count by 2',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'flareCount': 2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase flare speed by 15%',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'flareSpeed': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase flare damage by 2',
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
  double? get speed => _flareSpeed;

  @override
  void fire() {
    game.world.add(
      _FlareBurst(
        player: player,
        count: _flareCount,
        interval: _flareInterval,
        speed: _flareSpeed,
        damage: _damage,
        muzzleOffset: 0.2,
      ),
    );
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
        case 'flareSpeed':
          _flareSpeed *= value as double;
          break;
        case 'flareCount':
          _flareCount += value as int;
          break;
      }
    });
  }
}

class _FlareBurst extends Component with HasGameReference<SpaceGame> {
  final Player player;
  final int count;
  final double interval;
  final double speed;
  final double damage;
  final double muzzleOffset;
  final Random _rng = Random();

  double _elapsed = 0.0;
  int _spawned = 0;

  _FlareBurst({
    required this.player,
    required this.count,
    required this.interval,
    required this.speed,
    required this.damage,
    required this.muzzleOffset,
  });

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    while (_spawned < count && _elapsed >= interval * (_spawned + 1)) {
      final origin = player.ship.position -
          player.direction.scaled(player.ship.size.y * muzzleOffset);
      final baseAngle = player.ship.angle + pi;
      final spread = (_rng.nextDouble() - 0.5) * 1.2;
      final angularVelocity = (_rng.nextDouble() - 0.5) * 2.5;
      game.world.add(
        Flare(
          position: origin.clone(),
          speed: speed,
          damage: damage,
          penetration: 1,
          angle: baseAngle + spread,
          angularVelocity: angularVelocity,
        ),
      );
      _spawned += 1;
    }

    if (_spawned >= count) {
      removeFromParent();
    }
  }
}
