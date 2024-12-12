import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/level_system.dart';
import 'package:space_scape/components/xp.dart';
import 'package:space_scape/space_game.dart';

class PlayerShip extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  PlayerShip()
      : super(
          size: Vector2(1 * 32, 1 * 39),
          anchor: Anchor.center,
        );
  late final CircleHitbox collectRadiusHitbox;
  late final RectangleHitbox body;
  late final LevelSystem levelSystem;

  late TimerComponent bulletCreator;

  static const double iTime = 0.1;

  ValueNotifier<double> health = ValueNotifier<double>(100);
  ValueNotifier<double> shield = ValueNotifier<double>(0);

  Vector2 direction = Vector2(0, -1);
  Vector2 displacement = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  double iTimeLeft = 0;
  double maxHealth = 100;
  double maxShield = 0;

  double regenAmount = 1;
  double shieldRegenCooldown = 10;
  double shieldRegenCurrent = 0;
  double attackSpeed = 1;
  double bulletSpeed = 200;
  double acc = 65;
  double maxSpeed = 75;
  double brake = 2;
  double turnSpeed = 2;
  double collectRadius = 40;

  List<String> weapons = ['BasicShot'];
  List<double> bulletAngles = [0.0];

  @override
  Future<void> onLoad() async {
    levelSystem = LevelSystem(this);
    add(levelSystem);
    position = game.size / 2;
    body = RectangleHitbox(isSolid: true);
    add(body);
    collectRadiusHitbox = CircleHitbox(
        radius: collectRadius,
        position: -Vector2(
            collectRadius - size.x * 0.5, collectRadius - size.y * 0.5),
        isSolid: true)
      //..debugMode = true
      ..debugColor = Colors.blue.withOpacity(0.5);
    add(collectRadiusHitbox);

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
    await super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy && body.collidingWith(other.hitbox)) {
      if (iTimeLeft <= 0) takeHit(Enemy.damage);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is XP) {
      if (game.gameOver) return;
      other.moveToPlayer();
      if (body.collidingWith(other.hitbox)) {
        levelSystem.addXP(1);
        game.xp = levelSystem.currentXP;
        other.removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) return;
    direction = Vector2(0, -1)..rotate(angle);
    rotate(dt);
    move(dt);
    if (iTimeLeft > 0) iTimeLeft -= dt;
    if (shieldRegenCurrent > 0) shieldRegenCurrent -= dt;
    if (shieldRegenCurrent <= 0 && shield.value < maxShield) {
      shield.value = (shield.value + dt).clamp(0, maxShield);
    }
    if (health.value <= 0) {
      print('Game Over');
      game.gameOver = true;
      velocity = Vector2.zero();
    }
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

  void takeHit(double damage) {
    if (shield.value > 0) {
      iTimeLeft = iTime;
      shieldRegenCurrent = shieldRegenCooldown;
      shield.value = (shield.value - damage).clamp(0, maxShield);
    } else {
      iTimeLeft = iTime;
      game.world.add(Explosion(position: position, size: Vector2.all(20)));
      health.value = (health.value - damage).clamp(0, maxHealth);
    }
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
