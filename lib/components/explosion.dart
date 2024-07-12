import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_scape/space_scape.dart';

class Explosion extends SpriteAnimationComponent
    with HasGameReference<SpaceGame> {
  Explosion({
    super.position,
    super.size,
  }) : super(
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
    /* paint = Paint()
      ..color = Colors.blue // This sets the tint color
      ..colorFilter =
          ColorFilter.mode(Colors.blue.withOpacity(0.8), BlendMode.srcIn); */
  }
}
