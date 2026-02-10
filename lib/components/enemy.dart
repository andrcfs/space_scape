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
    Vector2? size,
    this.maxHealth = defaultMaxHealth,
    this.spritePath = 'enemy.png',
    this.frameCount = 4,
    Vector2? frameSize,
    Vector2? bodySizeFactor,
    Vector2? bodyOffsetFactor,
  })  : enemySize = size ?? Vector2.all(defaultEnemySize),
        frameSize = frameSize ?? Vector2.all(defaultFrameSize),
        bodySizeFactor = bodySizeFactor ?? Vector2.all(0.5),
        bodyOffsetFactor = bodyOffsetFactor ?? Vector2.all(0.25),
        super(
          size: size ?? Vector2.all(defaultEnemySize),
          anchor: Anchor.center,
          angle: 0,
        );

  static const double defaultEnemySize = 24.0;
  static const double defaultFrameSize = 16.0;
  static const double defaultMaxHealth = 1;
  static const double damage = 1;

  final Vector2 enemySize;
  final double maxHealth;
  final String spritePath;
  final int frameCount;
  final Vector2 frameSize;
  final Vector2 bodySizeFactor;
  final Vector2 bodyOffsetFactor;
  late double _health;
  late final RectangleHitbox hitbox;
  late final RectangleHitbox body;
  late Ray2 ray;
  double _updateTimer = 0.0;
  final double _updateInterval = .01;
  Vector2 direction = Vector2(0, 1);
  Vector2 collisionVector = Vector2(0, 0);
  double enemySpeed = 35.0;
  double turnSpeed = 1.5;
  static bool hasMovement = true;

  int xpDropRate = 50;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _health = maxHealth;
    hitbox = RectangleHitbox(collisionType: CollisionType.passive);
    body = RectangleHitbox(
      position: size.clone()..multiply(bodyOffsetFactor),
      size: size.clone()..multiply(bodySizeFactor),
      isSolid: true,
    );

    add(hitbox);
    add(body
      //..debugMode = true
      ..debugColor = Colors.red);
    animation = await game.loadSpriteAnimation(
      spritePath,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: .2,
        textureSize: frameSize,
      ),
    );
    //game.add(LineComponent(start: position, end: game.player.position));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (hasMovement) {
      _updateTimer += dt;
      if (_updateTimer >= _updateInterval) {
        _updateTimer = 0.0;
        facePlayer(dt);
      }
      position += direction * dt * enemySpeed;
    }
  }

  void facePlayer(double dt) {
    var playerDirection = game.player.ship.position - position;
    if (playerDirection.angleToSigned(direction).abs() > 0.1) {
      changeDirection(playerDirection.angleToSigned(direction), dt);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      if (other.body.collidingWith(body)) {
        collisionVector = other.position - position;

        Vector2 perpendicular = Vector2(-direction.y, direction.x);
        Vector2 perpColVector = collisionVector.projection(perpendicular);
        final collisionRadius = size.x * 0.5;
        double value =
            -0.5 * perpColVector.length2 / (collisionRadius * collisionRadius) +
                0.5;
        if (collisionVector.angleToSigned(direction) > 0) {
          position += perpendicular.scaled(value.clamp(0.1, 10));
        } else {
          position -= perpendicular.scaled(value.clamp(0.1, 10));
        }
      }
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
      takeDamage(other.damage);
    }
    if (other is Player) {
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

  void takeDamage(double amount) {
    if (amount <= 0) {
      return;
    }
    _health -= amount;
    if (_health <= 0) {
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
