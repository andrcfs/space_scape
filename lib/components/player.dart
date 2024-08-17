import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/xp.dart';
import 'package:space_scape/space_game.dart';

class PlayerShip extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  PlayerShip()
      : super(
          size: Vector2(1.1 * 32, 1.1 * 39),
          anchor: Anchor.center,
        );
  late TimerComponent bulletCreator;
  Vector2 direction = Vector2(0, -1);
  Vector2 displacement = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  double attackSpeed = 1;
  double bulletSpeed = 200;
  double acc = 50;
  double maxSpeed = 65;
  double brake = 2;
  double turnSpeed = 2;
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
        period: 1 / attackSpeed,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {
      takeHit();
    }
    if (other is XP) {
      game.increaseXP();
      other.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    direction = Vector2(0, -1)..rotate(angle);
    rotate(dt);
    move(dt);
  }

  void _createBullet() {
    game.world.addAll(
      bulletAngles.map(
        (angles) {
          return Bullet(
            position: position + direction.scaled(size.y / 2),
            speed: bulletSpeed,
            angle: angle + angles,
          );
        },
      ),
    );
  }

  void takeHit() {
    game.world.add(Explosion(position: position, size: Vector2.all(20)));
  }

  void rotate(double delta) {
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyA) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      angle -= delta * turnSpeed;
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyD) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      angle += delta * turnSpeed;
    }
  }

  void move(double delta) {
    acceleration(delta);
    displacement = velocity * delta;
    position += displacement;
    //displacement =  direction.normalized().scaled(velocity) * delta;
  }

  void acceleration(double delta) {
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyW) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      velocity += direction.normalized().scaled(acc) * delta;
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyS) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      velocity += direction.normalized().scaled(-acc / brake) * delta;
    }
    if (velocity.length > maxSpeed) {
      velocity = velocity.normalized().scaled(maxSpeed);
    }
  }

  void move2(Vector2 delta) {
    position.add(delta);
  }
}
