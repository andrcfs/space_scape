import 'dart:ui';

import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/upgrade.dart';
import 'package:space_scape/space_game.dart';

import 'weapon.dart';

class LaserBeamWeapon extends Weapon {
  double _damage = 1.0;
  double _cooldown = 2.0;
  double _range = 2200.0;
  double _beamWidth = 20.8;

  static const double _beamDuration = 0.29;
  static const double _fadeSlowdown = 1.15;
  static const double _hitboxWidthScale = 1.82;

  LaserBeamWeapon({
    required super.player,
    super.name = 'Laser Beam',
    super.description = 'Fires a long beam that pierces enemies',
    super.iconPath = 'bullet.png',
    super.unlocked = true,
  }) : super(weaponId: 'laserbeam_weapon') {
    initUpgrades([
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Unlock laser beam',
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
        description: 'Increase beam range by 20%',
        level: 2,
        upgradeType: UpgradeType.weapon,
        statChanges: {'range': 1.2},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase beam width by 20%',
        level: 3,
        upgradeType: UpgradeType.weapon,
        statChanges: {'width': 1.2},
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
        description: 'Increase beam range by 15%',
        level: 5,
        upgradeType: UpgradeType.weapon,
        statChanges: {'range': 1.15},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase damage by 1',
        level: 6,
        upgradeType: UpgradeType.weapon,
        statChanges: {'damage': 1.0},
      ),
      UpgradeLevel(
        name: name,
        icon: iconPath,
        description: 'Increase beam width by 20%',
        level: 7,
        upgradeType: UpgradeType.weapon,
        statChanges: {'width': 1.2},
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
    final direction = player.direction.normalized();
    final endPosition = startPosition + direction * _range;

    game.world.add(
      _LaserBeamSprite(
        start: startPosition.clone(),
        end: endPosition.clone(),
        duration: _beamDuration,
        width: _beamWidth,
      ),
    );

    final enemies = game.world.children.whereType<Enemy>();
    final maxDistance = _range;
    final halfWidth = _beamWidth * 0.5 * _hitboxWidthScale;

    for (final enemy in enemies) {
      final toEnemy = enemy.position - startPosition;
      final projected = toEnemy.dot(direction);
      if (projected < 0 || projected > maxDistance) {
        continue;
      }
      final closestPoint = startPosition + direction * projected;
      final distanceToLine = enemy.position.distanceTo(closestPoint);
      if (distanceToLine <= halfWidth) {
        enemy.takeDamage(damage);
      }
    }
  }

  Vector2 _getMuzzlePosition() {
    return player.ship.position +
        player.direction.scaled(player.ship.size.y / 2);
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
        case 'width':
          _beamWidth *= value as double;
          break;
      }
    });
  }
}

class _LaserBeamSprite extends Component with HasGameReference<SpaceGame> {
  static const String _spritePath = 'laser.png';
  static const double _headWidth = 18.0;
  static const double _headHeight = 195.0;
  static const double _bodyWidth = 22.0;
  static const double _bodyHeight = 195.0;
  static final Vector2 _bodyStartPixel = Vector2(8, 1);
  static final Vector2 _bodyEndPixel = Vector2(8, 194);

  static const double _fadeSlowdown = 1.15;

  final Vector2 start;
  final Vector2 end;
  final double duration;
  final double width;
  double _elapsed = 0.0;
  late final Sprite _bodySprite;

  _LaserBeamSprite({
    required this.start,
    required this.end,
    required this.duration,
    required this.width,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _bodySprite = await game.loadSprite(
      _spritePath,
      srcPosition: Vector2(_headWidth, 0),
      srcSize: Vector2(_bodyWidth, _bodyHeight),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_elapsed >= duration) {
      return;
    }

    final direction = (end - start).normalized();
    final beamLength = end.distanceTo(start);
    if (beamLength <= 0.0) {
      return;
    }

    final baseVector = Vector2(0, 1);
    final angle = baseVector.angleToSigned(direction);

    final bodyBaseLength = (_bodyEndPixel - _bodyStartPixel).length;
    final bodyWidthScale = width / _bodyWidth;
    final bodyLengthScale =
        bodyBaseLength == 0.0 ? 1.0 : (beamLength / bodyBaseLength);
    final bodyScale = Vector2(bodyWidthScale, bodyLengthScale);
    final bodyStart = start;
    _renderSegment(
      canvas,
      sprite: _bodySprite,
      position: bodyStart,
      angle: angle,
      anchorPixel: _bodyStartPixel,
      scale: bodyScale,
      opacity: _currentOpacity(),
    );
  }

  void _renderSegment(
    Canvas canvas, {
    required Sprite sprite,
    required Vector2 position,
    required double angle,
    required Vector2 anchorPixel,
    required Vector2 scale,
    required double opacity,
  }) {
    final drawOffset = Vector2(
      -anchorPixel.x * scale.x,
      -anchorPixel.y * scale.y,
    );
    final drawSize = Vector2(
      sprite.srcSize.x * scale.x,
      sprite.srcSize.y * scale.y,
    );
    final paint = Paint()
      ..color = Color.fromARGB((255 * opacity).round(), 255, 255, 255);

    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(angle);
    sprite.render(canvas, position: drawOffset, size: drawSize);
    if (opacity < 1.0) {
      final fadePaint = Paint()
        ..blendMode = BlendMode.modulate
        ..color = Color.fromARGB((255 * opacity).round(), 255, 255, 255);
      canvas.drawRect(Offset.zero & drawSize.toSize(), fadePaint);
    }
    canvas.restore();
  }

  double _currentOpacity() {
    final t = (_elapsed / (duration * _fadeSlowdown)).clamp(0.0, 1.0);
    return (1.0 - t).clamp(0.0, 1.0);
  }
}
