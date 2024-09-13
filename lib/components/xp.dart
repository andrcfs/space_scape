import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/space_game.dart';

class XP extends SpriteComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  XP({super.position})
      : super(
          size: Vector2(16, 16),
          anchor: Anchor.center,
        );
  final image = 'xpdrop.png';
  late final CircleHitbox hitbox;
  bool startMoving = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    hitbox = CircleHitbox(collisionType: CollisionType.passive);
    add(hitbox);
    sprite = await game.loadSprite(
      image,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 direction = game.player.position - position;
    if (startMoving) {
      direction.normalize();
      position += direction * dt * 200;
    }
  }

  void moveToPlayer() {
    startMoving = true;
  }
}
