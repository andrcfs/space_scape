import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/game.dart';

class XP extends SpriteComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  XP({super.position})
      : super(
          size: Vector2(16, 16),
          anchor: Anchor.center,
        );
  final image = 'xpdrop.png';
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.passive));
    sprite = await game.loadSprite(
      image,
    );
  }
}
