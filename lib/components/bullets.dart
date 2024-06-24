import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/game.dart';

class Bullet extends SpriteAnimationComponent with HasGameReference<SpaceGame> {
  Bullet({super.position, required this.speed, super.angle})
      : super(
          size: Vector2(6.25, 12.5),
          anchor: Anchor.center,
        );
  int penetration = 2;
  final double speed;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();

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

    if (position.y < 0 || position.x > game.size.x || position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
