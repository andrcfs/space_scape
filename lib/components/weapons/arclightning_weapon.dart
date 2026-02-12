import 'dart:ui';

import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/upgrade.dart';
import 'package:space_scape/space_game.dart';

import 'weapon.dart';

class ArcLightningWeapon extends Weapon {
  double _damage = 1.0;
  double _cooldown = 1.6;
  double _range = 120.0;
  double _chainRange = 90.0;
  int _maxChains = 3;

  static const double _frontDotThreshold = 0.3;
  static const double _boltTravelDuration = 0.4;

  ArcLightningWeapon({
    required super.player,
    super.name = 'Arc Lightning',
    super.description = 'Zaps enemies in front, chaining to nearby targets',
    super.iconPath = 'bullet.png',
    super.unlocked = true,
  }) : super(weaponId: 'arclightning_weapon') {
    initUpgrades([
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Unlock arc lightning',
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
        description: 'Increase zap range by 15%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'range': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase chain range by 15%',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'chainRange': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Add one more chain target',
        level: 4,
        upgradeType: UpgradeType.weapon,
        statChanges: {'chains': 1},
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
        description: 'Increase zap range by 20%',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'range': 1.2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage by 1',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 1.0},
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
    final startPosition = _getMuzzlePosition();
    final firstTarget = _findFirstTarget(startPosition);
    if (firstTarget == null) {
      return;
    }

    final targets = <Enemy>[firstTarget];
    final hit = <Enemy>{firstTarget};
    var current = firstTarget;

    while (targets.length < _maxChains) {
      final nextTarget = _findNextTarget(current, hit);
      if (nextTarget == null) {
        break;
      }
      targets.add(nextTarget);
      hit.add(nextTarget);
      current = nextTarget;
    }

    _zapTargets(startPosition, targets);
  }

  Vector2 _getMuzzlePosition() {
    return player.ship.position +
        player.direction.scaled(player.ship.size.y / 2);
  }

  Enemy? _findFirstTarget(Vector2 startPosition) {
    final enemies = game.world.children.whereType<Enemy>();
    Enemy? best;
    var bestDistance = double.infinity;

    for (final enemy in enemies) {
      final toEnemy = enemy.position - startPosition;
      final distance = toEnemy.length;
      if (distance > _range) {
        continue;
      }
      final dot = player.direction.dot(toEnemy.normalized());
      if (dot < _frontDotThreshold) {
        continue;
      }
      if (distance < bestDistance) {
        bestDistance = distance;
        best = enemy;
      }
    }

    return best;
  }

  Enemy? _findNextTarget(Enemy from, Set<Enemy> hit) {
    final enemies = game.world.children.whereType<Enemy>();
    Enemy? best;
    var bestDistance = double.infinity;

    for (final enemy in enemies) {
      if (hit.contains(enemy)) {
        continue;
      }
      final distance = enemy.position.distanceTo(from.position);
      if (distance > _chainRange) {
        continue;
      }
      if (distance < bestDistance) {
        bestDistance = distance;
        best = enemy;
      }
    }

    return best;
  }

  void _zapTargets(Vector2 startPosition, List<Enemy> targets) {
    game.world.add(
      _ArcLightningChain(
        start: startPosition.clone(),
        targets: targets,
        damage: damage,
        segmentDuration: _boltTravelDuration,
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
        case 'range':
          _range *= value as double;
          break;
        case 'chainRange':
          _chainRange *= value as double;
          break;
        case 'chains':
          _maxChains += value as int;
          break;
      }
    });
  }
}

class _ArcLightningChain extends Component with HasGameReference<SpaceGame> {
  static final Vector2 _spriteSize = Vector2(67, 32);
  static final List<_BoltFrame> _frames = [
    _BoltFrame(
      path: 'lightning1.png',
      startPixel: Vector2(17, 28),
      endPixel: Vector2(56, 29),
    ),
    _BoltFrame(
      path: 'lightning2.png',
      startPixel: Vector2(21, 33),
      endPixel: Vector2(59, 32),
    ),
    _BoltFrame(
      path: 'lightning3.png',
      startPixel: Vector2(18, 37),
      endPixel: Vector2(68, 45),
    ),
    _BoltFrame(
      path: 'lightning4.png',
      startPixel: Vector2(16, 31),
      endPixel: Vector2(54, 29),
    ),
  ];
  static const double _frameDuration = 0.12;

  final Vector2 start;
  final List<Enemy> targets;
  final double damage;
  final double segmentDuration;

  late final List<Sprite> _sprites;
  int _segmentIndex = 0;
  double _segmentProgress = 0.0;
  Vector2 _segmentStart = Vector2.zero();
  int _frameIndex = 0;
  double _frameTimer = 0.0;

  _ArcLightningChain({
    required this.start,
    required this.targets,
    required this.damage,
    required this.segmentDuration,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _sprites = [];
    for (final frame in _frames) {
      _sprites.add(await game.loadSprite(frame.path));
    }
    _segmentStart = start.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_segmentIndex >= targets.length) {
      removeFromParent();
      return;
    }

    _frameTimer += dt;
    if (_frameTimer >= _frameDuration) {
      _frameTimer -= _frameDuration;
      _frameIndex = (_frameIndex + 1) % _frames.length;
    }

    _segmentProgress += dt / segmentDuration;
    if (_segmentProgress >= 1.0) {
      final target = targets[_segmentIndex];
      target.takeDamage(damage);
      _segmentIndex += 1;
      _segmentProgress = 0.0;
      _segmentStart = target.position.clone();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_segmentIndex >= targets.length) {
      return;
    }

    final target = targets[_segmentIndex];
    final end = target.position.clone();
    final segmentVector = end - _segmentStart;
    final segmentLength = segmentVector.length;
    if (segmentLength <= 0.0) {
      return;
    }

    final currentEnd = _segmentStart +
        segmentVector.normalized() * (segmentLength * _segmentProgress);
    _renderBolt(canvas, _segmentStart, currentEnd);
    _renderBolt(canvas, _segmentStart, end);
  }

  void _renderBolt(Canvas canvas, Vector2 boltStart, Vector2 boltEnd) {
    final boltVector = boltEnd - boltStart;
    final boltLength = boltVector.length;
    if (boltLength <= 0.0) {
      return;
    }

    final frame = _frames[_frameIndex];
    final sprite = _sprites[_frameIndex];
    final baseVector = frame.endPixel - frame.startPixel;
    final baseLength = baseVector.length;
    if (baseLength <= 0.0) {
      return;
    }

    final scale = boltLength / baseLength;
    final angle = boltVector.angleToSigned(Vector2(1, 0)) -
        baseVector.angleToSigned(Vector2(1, 0));

    final drawOffset = -frame.startPixel * scale;
    final drawSize = _spriteSize * scale;

    canvas.save();
    canvas.translate(boltStart.x, boltStart.y);
    canvas.rotate(angle);
    sprite.render(
      canvas,
      position: drawOffset,
      size: drawSize,
    );
    canvas.restore();
  }
}

class _BoltFrame {
  final String path;
  final Vector2 startPixel;
  final Vector2 endPixel;

  const _BoltFrame({
    required this.path,
    required this.startPixel,
    required this.endPixel,
  });
}
