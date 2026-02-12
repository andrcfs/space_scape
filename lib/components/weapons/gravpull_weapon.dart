import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/upgrade.dart';
import 'package:space_scape/space_game.dart';

import 'weapon.dart';

class GravPullWeapon extends Weapon {
  double _damage = 0.0;
  double _cooldown = 4.8;
  double _range = 240.0;
  double _projectileSpeed = 180.0;
  double _fieldRadius = 110.0;
  double _pullStrength = 70.0;
  double _fieldDuration = 4.0;

  GravPullWeapon({
    required super.player,
    super.name = 'Grav Pull',
    super.description = 'Launches a gravity well that pulls enemies in pulses',
    super.iconPath = 'bullet.png',
    super.unlocked = true,
  }) : super(weaponId: 'gravpull_weapon') {
    initUpgrades([
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Unlock grav pull',
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
        description: 'Increase field radius by 15%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'radius': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase pull strength by 20%',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'pull': 1.2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase travel range by 20%',
        level: 4,
        upgradeType: UpgradeType.weapon,
        statChanges: {'range': 1.2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Reduce cooldown by 10%',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'cooldown': 0.9},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase field duration by 1.0s',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'duration': 1.0},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase pull strength by 20%',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {'pull': 1.2},
      ),
    ]);
  }

  @override
  double get damage => _damage;

  @override
  double get cooldown => _cooldown;

  @override
  double? get range => _range;

  @override
  void fire() {
    final muzzle =
        player.ship.position + player.direction.scaled(player.ship.size.y / 2);
    final direction = player.direction.normalized();

    game.world.add(
      _GravPullProjectile(
        startPosition: muzzle,
        direction: direction,
        speed: _projectileSpeed,
        maxDistance: _range,
        fieldRadius: _fieldRadius,
        fieldDuration: _fieldDuration,
        pullStrength: _pullStrength,
      ),
    );
  }

  @override
  void upgradeStats(Map<String, dynamic> stats) {
    stats.forEach((key, value) {
      switch (key) {
        case 'cooldown':
          _cooldown *= value as double;
          break;
        case 'radius':
          _fieldRadius *= value as double;
          break;
        case 'pull':
          _pullStrength *= value as double;
          break;
        case 'range':
          _range *= value as double;
          break;
        case 'duration':
          _fieldDuration += value as double;
          break;
        case 'damage':
          _damage += value as double;
          break;
      }
    });
  }
}

class _GravPullProjectile extends PositionComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed;
  final double maxDistance;
  final double fieldRadius;
  final double fieldDuration;
  final double pullStrength;

  Vector2 _traveled = Vector2.zero();
  bool _hasTriggered = false;

  _GravPullProjectile({
    required Vector2 startPosition,
    required this.direction,
    required this.speed,
    required this.maxDistance,
    required this.fieldRadius,
    required this.fieldDuration,
    required this.pullStrength,
  }) : super(
          position: startPosition.clone(),
          size: Vector2.all(12),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final step = direction * speed * dt;
    position += step;
    _traveled += step;

    if (_traveled.length >= maxDistance) {
      _spawnField();
    }
  }

  void _spawnField() {
    if (_hasTriggered) {
      return;
    }
    _hasTriggered = true;
    game.world.add(
      _GravPullField(
        center: position.clone(),
        radius: fieldRadius,
        duration: fieldDuration,
        pullStrength: pullStrength,
      ),
    );
    removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      _spawnField();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color(0xFFB977FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size.x * 0.5, paint);
  }
}

class _GravPullField extends SpriteAnimationComponent
    with HasGameReference<SpaceGame> {
  final Vector2 center;
  final double radius;
  final double duration;
  final double pullStrength;

  static const int _frameCount = 8;
  static const List<int> _frameOrder = [4, 5, 6, 7, 0, 1, 2, 3];
  static const double _frameSizePx = 512.0;
  static const double _basePulseDiameter = 478.0;
  static const String _spritePath = 'pulses.png';
  static const double _frameTime = 0.5;
  static const Map<int, double> _pulseDiameters = {
    1: 478.0,
    2: 348.0,
    3: 306.0,
  };

  double _elapsed = 0.0;
  int _lastFrameIndex = -1;
  late final double _scale;

  _GravPullField({
    required this.center,
    required this.radius,
    required this.duration,
    required this.pullStrength,
  }) : super(anchor: Anchor.center) {
    _scale = (radius * 2) / _basePulseDiameter;
    size = Vector2.all(_frameSizePx * _scale);
    position = center.clone();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final frames = <SpriteAnimationFrame>[];
    for (final frameIndex in _frameOrder) {
      final sprite = await game.loadSprite(
        _spritePath,
        srcPosition: Vector2(frameIndex * _frameSizePx, 0),
        srcSize: Vector2.all(_frameSizePx),
      );
      frames.add(SpriteAnimationFrame(sprite, _frameTime));
    }
    animation = SpriteAnimation(frames, loop: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    final frameIndex =
        ((_elapsed / _frameTime).floor() % _frameOrder.length).toInt();
    if (frameIndex != _lastFrameIndex) {
      _lastFrameIndex = frameIndex;
      final sourceFrame = _frameOrder[frameIndex];
      final diameter = _pulseDiameters[sourceFrame];
      if (diameter != null) {
        _emitPulse(diameter);
      }
    }

    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  void _emitPulse(double pulseDiameter) {
    final pulseRadius = (pulseDiameter * 0.5) * _scale;

    final enemies = game.world.children.whereType<Enemy>();
    for (final enemy in enemies) {
      final delta = center - enemy.position;
      final distance = delta.length;
      if (distance > pulseRadius || distance == 0) {
        continue;
      }
      final strength = pullStrength * 1.25 * (1 - (distance / pulseRadius));
      enemy.position += delta.normalized() * strength;
    }
  }
}
