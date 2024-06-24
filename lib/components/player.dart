import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/game.dart';

class PlayerShip extends SpriteAnimationComponent
    with HasGameReference<SpaceGame> {
  PlayerShip()
      : super(
          size: Vector2(1.3 * 32, 1.3 * 39),
          anchor: Anchor.center,
        );

  late final SpawnComponent _bulletSpawner;
  late TimerComponent bulletCreator;
  double attackSpeed = 1;
  double bulletSpeed = 200;
  List<double> bulletAngles = [0.0];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = game.size / 2;
    add(RectangleHitbox());

    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 39),
      ),
    );
    add(
      bulletCreator = TimerComponent(
        period: 0.05,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );

    game.add(_bulletSpawner);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void _createBullet() {
    game.addAll(
      bulletAngles.map(
        (angle) => Bullet(
          position: position + Vector2(0, -size.y / 2),
          speed: bulletSpeed,
          angle: angle,
        ),
      ),
    );
  }
}







 /* _bulletSpawner = SpawnComponent(
      period: attackSpeed,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
                0,
                -height / 2,
              ),
          speed: 200,
        );
      },
      autoStart: true,
    ); */