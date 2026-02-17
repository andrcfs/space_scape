import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/space_game.dart';

class EnemyChaserMissile extends PositionComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  EnemyChaserMissile({
    required Vector2 position,
    required Vector2 direction,
    required this.speed,
    required this.damage,
    this.turnRate = 3.0,
    this.lifetime = 6.0,
  })  : _direction = direction.normalized(),
        super(
          position: position,
          size: Vector2.all(6),
          anchor: Anchor.center,
        );

  final double speed;
  final double damage;
  final double turnRate;
  final double lifetime;

  Vector2 _direction;
  double _age = 0.0;
  Enemy? _target;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
    _target = _findNearestEnemy();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= lifetime) {
      removeFromParent();
      return;
    }

    if (_target == null || !_target!.isMounted) {
      _target = _findNearestEnemy();
    }

    if (_target != null) {
      final desired = (_target!.position - position).normalized();
      final angleDelta = _direction.angleToSigned(desired);
      final maxTurn = turnRate * dt;
      final clamped = angleDelta.clamp(-maxTurn, maxTurn);
      _direction = _direction..rotate(clamped);
    }

    position += _direction * speed * dt;
    angle = atan2(_direction.y, _direction.x); // Orient the missile to face its direction
  }

  Enemy? _findNearestEnemy() {
    Enemy? nearest;
    var bestDist2 = double.infinity;
    for (final enemy in game.world.children.whereType<Enemy>()) {
      final dx = enemy.position.x - position.x;
      final dy = enemy.position.y - position.y;
      final dist2 = dx * dx + dy * dy;
      if (dist2 < bestDist2) {
        bestDist2 = dist2;
        nearest = enemy;
      }
    }
    return nearest;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      other.takeDamage(damage);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size.x * 0.5, paint);
    final tailPaint = Paint()
      ..color = const Color(0xFFFFA500)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final tail = Offset(-size.x, 0);
    canvas.drawLine(Offset.zero, tail, tailPaint);
  }
}
