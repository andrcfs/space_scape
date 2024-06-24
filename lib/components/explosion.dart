import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_scape/game.dart';

class Explosion extends SpriteAnimationComponent
    with HasGameReference<SpaceGame> {
  Explosion({
    super.position,
  }) : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: .1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
