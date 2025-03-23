import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/space_game.dart';

class Bullet extends SpriteAnimationComponent with HasGameReference<SpaceGame> {
  Bullet({
    super.position,
    super.angle,
    required this.speed,
    required this.damage,
    required this.penetration,
  }) : super(
          size: Vector2(6.25, 12.5),
          anchor: Anchor.center,
        );

  final double speed;
  final double damage;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();
  int penetration;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(CircleHitbox(collisionType: CollisionType.active));
    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(8, 16),
      ),
    );
    velocity = Vector2(0, -1)
      ..rotate(angle)
      ..scale(speed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    deltaPosition
      ..setFrom(velocity)
      ..scale(dt);
    position += deltaPosition;

    if (!game.camera.canSee(this)) {
      removeFromParent();
    }
  }
}
