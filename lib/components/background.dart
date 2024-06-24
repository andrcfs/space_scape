import 'package:flame/components.dart';
import 'package:space_scape/game.dart';

class Background extends SpriteComponent with HasGameReference<SpaceGame> {
  Background()
      : super(
          size: Vector2(500, 500),
          anchor: Anchor.center,
          position: Vector2(1000, 100),
        );
  final image = 'planet08.png';
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite(
      image,
    );
  }
}
