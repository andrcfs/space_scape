import 'dart:ui';

import 'package:flame/components.dart';

import '../space_game.dart';
import 'ships/ship.dart';

class ShieldEffect extends SpriteAnimationComponent
    with HasGameReference<SpaceGame> {
  static const double _frameWidth = 213 / 4;
  static const double _frameHeight = 53;
  static const double _centerX = 26;
  static const double _centerY = 27;

  final Ship ship;

  ShieldEffect(this.ship)
      : super(
          size: Vector2(_frameWidth, _frameHeight),
          anchor: Anchor.topLeft,
          position: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'shield.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.12,
        textureSize: Vector2(_frameWidth, _frameHeight),
      ),
    );
    position = ship.size / 2 - Vector2(_centerX, _centerY);
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if (ship.shieldEffectTimer <= 0) {
      return;
    }
    super.render(canvas);
  }
}
