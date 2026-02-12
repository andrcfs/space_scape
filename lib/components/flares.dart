import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/space_game.dart';

class Flare extends PositionComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  static const double _lifetime = 6.0;
  static const double _fadeDuration = 1.5;
  Flare({
    super.position,
    required this.speed,
    required this.damage,
    required this.penetration,
    double? angle,
    double? angularVelocity,
  })  : _angle = angle ?? Random().nextDouble() * pi * 2,
        _angularVelocity =
            angularVelocity ?? (Random().nextDouble() - 0.5) * 2.0,
        super(
          size: Vector2(8, 16),
          anchor: Anchor.center,
        );

  final double speed;
  final double damage;
  final int penetration;
  double _angle;
  double _angularVelocity;
  final Vector2 _velocity = Vector2.zero();
  final Random _rng = Random();
  double _age = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    _angularVelocity += (_rng.nextDouble() - 0.5) * 0.8 * dt;
    _angularVelocity = _angularVelocity.clamp(-3.0, 3.0);
    _angle += _angularVelocity * dt;
    final angle = _angle;
    _velocity
      ..setValues(cos(angle), sin(angle))
      ..scale(speed);
    position += _velocity * dt;

    if (_age >= _lifetime || !game.camera.canSee(this)) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final opacity = _fadeOpacity();
    final direction =
        _velocity.length == 0 ? Vector2(0, 1) : _velocity.normalized();
    _renderGlowTail(canvas, direction, opacity);
    final paint = Paint()
      ..color = Color.fromARGB((255 * opacity).round(), 255, 255, 255)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size.x * 0.35, paint);
  }

  void _renderGlowTail(Canvas canvas, Vector2 direction, double opacity) {
    final tailLength = size.y * 3.6;
    final tailSteps = 6;
    final step = tailLength / tailSteps;
    for (var i = 1; i <= tailSteps; i += 1) {
      final t = i / tailSteps;
      final fade = (1.0 - t) * opacity;
      final radius = size.x * (0.35 * (1.0 - t * 0.5));
      final offset = direction.scaled(-step * i).toOffset();
      final paint = Paint()
        ..color = Color.fromARGB((160 * fade).round(), 255, 255, 255)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  double _fadeOpacity() {
    if (_age <= _lifetime - _fadeDuration) {
      return 1.0;
    }
    final t =
        ((_age - (_lifetime - _fadeDuration)) / _fadeDuration).clamp(0.0, 1.0);
    return (1.0 - t).clamp(0.0, 1.0);
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
}
