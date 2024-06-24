import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/game.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 25.0;
  static const enemySpeed = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * enemySpeed;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    void enemyDeath() {
      game.add(Explosion(position: position));
      removeFromParent();
    }

    if (other is Bullet) {
      if (other.penetration <= 1) {
        other.removeFromParent();
      }
      other.penetration -= 1;
      enemyDeath();
    }
    if (other is PlayerShip) {
      enemyDeath();
    }
  }
}
