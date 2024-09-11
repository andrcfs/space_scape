import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/components/xp.dart';
import 'package:space_scape/space_game.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
          angle: 0,
        );

  static const double enemySize = 24.0;
  static const double maxHealth = 1;
  static const double enemySpeed = 35.0;
  static const double damage = 1;
  late final RectangleHitbox hitbox;
  late final RectangleHitbox body;
  late Ray2 ray;
  double _updateTimer = 0.0;
  final double _updateInterval = .01;
  Vector2 direction = Vector2(0, 1);
  Vector2 collisionVector = Vector2(0, 0);
  double turnSpeed = 1.5;

  int xpDropRate = 50;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    hitbox = RectangleHitbox(collisionType: CollisionType.passive);
    body = RectangleHitbox(position: size / 4, size: size / 2, isSolid: true);

    add(hitbox);
    add(body
      //..debugMode = true
      ..debugColor = Colors.red);
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );
    //game.add(LineComponent(start: position, end: game.player.position));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateTimer += dt;
    if (_updateTimer >= _updateInterval) {
      _updateTimer = 0.0;
      var playerDirection = game.player.position - position;
      if (playerDirection.angleToSigned(direction).abs() > 0.1) {
        changeDirection(playerDirection.angleToSigned(direction), dt);
      }
    }
    position += direction * dt * enemySpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      if (other.body.collidingWith(body)) {
        collisionVector = other.position - position;

        Vector2 perpendicular = Vector2(-direction.y, direction.x);
        Vector2 perpColVector = collisionVector.projection(perpendicular);
        double value =
            -0.5 * perpColVector.length2 / (enemySize / 2 * enemySize / 2) +
                0.5;
        if (collisionVector.angleToSigned(direction) > 0) {
          position += perpendicular.scaled(value.clamp(0.1, 10));
        } else {
          position -= perpendicular.scaled(value.clamp(0.1, 10));
        }
      }
    }
    if (other is PlayerShip) {
      if (other.iTimeLeft <= 0) other.takeHit(damage);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      if (other.penetration <= 1) {
        other.removeFromParent();
      }
      other.penetration -= 1;
      enemyDeath();
    }
    if (other is PlayerShip) {
      //enemyDeath();
    }
  }

  void enemyDeath() {
    game.world.add(Explosion(position: position, size: Vector2.all(50)));
    if (Random().nextInt(100) < xpDropRate) {
      game.world.add(XP(position: position));
    }
    removeFromParent();
  }

  void changeDirection(double angleBetween, double dt) {
    if (angleBetween > 0) {
      angle -= dt * turnSpeed;
    }
    if (angleBetween < 0) {
      angle += dt * turnSpeed;
    }
    direction = Vector2(0, 1)..rotate(angle);
  }
}

class LineComponent extends Component {
  // Start and end points of the line
  final Vector2 start;
  final Vector2 end;
  final Paint paint;

  LineComponent({
    required this.start,
    required this.end,
    Color color = Colors.blue,
    double strokeWidth = 2.0,
  }) : paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the line on the canvas
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }
}
