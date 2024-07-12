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
import 'package:space_scape/space_scape.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
          angle: 0,
        );

  static const enemySize = 25.0;
  static const enemySpeed = 35.0;
  late Ray2 ray;
  Vector2 direction = Vector2(0, 1);
  double turnSpeed = 1.5;

  int xpDropRate = 50;

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
    //game.add(LineComponent(start: position, end: game.player.position));
  }

  @override
  void update(double dt) {
    super.update(dt);
    var playerDirection = game.player.position - position;
    if (playerDirection.angleToSigned(direction).abs() > 0.1) {
      changeDirection(playerDirection.angleToSigned(direction), dt);
    }
    direction = Vector2(0, 1)..rotate(angle);
    position += direction * dt * enemySpeed;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    void enemyDeath() {
      game.world.add(Explosion(position: position, size: Vector2.all(50)));
      if (Random().nextInt(100) < xpDropRate) {
        game.world.add(XP(position: position));
      }
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

  void changeDirection(double angleBetween, double dt) {
    if (angleBetween > 0) {
      angle -= dt * turnSpeed;
    }
    if (angleBetween < 0) {
      angle += dt * turnSpeed;
    }
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
