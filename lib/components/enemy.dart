import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/bullets.dart';
import 'package:space_scape/space_game.dart';

import 'damage_notification.dart';

abstract class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  Enemy({
    super.position,
    Vector2? size,
  }) : super(
          size: size ?? Vector2.all(24.0),
          anchor: Anchor.center,
          angle: 0,
        );

  late final RectangleHitbox hitbox;
  late final RectangleHitbox body;
  bool _isTakingDamage = false;
  bool get isTakingDamage => _isTakingDamage;
  double _fallBackTime = 0.0;
  double _fallBackForce = 0.0;
  static const double fallBackDuration = 0.5;
  double _updateTimer = 0.0;
  late double _health;
  static const double _updateInterval = .01;
  Vector2 direction = Vector2(0, 1);
  Vector2 _playerDirection = Vector2.zero();
  Vector2 collisionVector = Vector2(0, 0);
  static bool hasMovement = true;

  // Abstract properties that need to be defined by subclasses
  double get enemySpeed;
  double get turnSpeed;
  double get maxHealth;
  static double damage = 1.0;
  int get xpDropRate;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _health = maxHealth;
    hitbox = RectangleHitbox(collisionType: CollisionType.passive);
    body = RectangleHitbox(
        position: size / 4,
        size: size / 2,
        isSolid: true,
        collisionType: CollisionType.active);
    _health = maxHealth;

    add(hitbox);
    add(body);

    // Load the animation in the subclass implementation
    await loadAnimation();
  }

  // Abstract method for loading the specific enemy animation
  Future<void> loadAnimation();

  @override
  void update(double dt) {
    super.update(dt);
    if (hasMovement) {
      _updateTimer += dt;
      if (_updateTimer >= _updateInterval) {
        _updateTimer = 0.0;
        facePlayer(dt);
      }
      double fallbackForce = 0.0;
      if (_isTakingDamage) {
        _fallBackTime += dt;
        if (_fallBackTime >= fallBackDuration) {
          _isTakingDamage = false;
          _fallBackTime = 0.0;
        }

        fallbackForce =
            _fallBackForce * (1.0 - (_fallBackTime / fallBackDuration));
      }
      position += _playerDirection * dt * enemySpeed * (1 - fallbackForce);
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
            -0.5 * perpColVector.length2 / (size.x / 2 * size.y / 2) + 0.5;
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
      //Subtract penetration from the bullet
      if (other.penetration <= 1) {
        other.removeFromParent();
      }
      other.penetration -= 1;
    }
  }

  void takeDamage(double damage, double pushForce) {
    if (_isTakingDamage == false) {
      _fallBackForce = pushForce;
      _isTakingDamage = true;
    }
    _health -= damage;
    final damageNotification = DamageNotification(
      damageAmount: damage,
      position: center,
    );
    game.world.add(damageNotification);

    if (_health <= 0) {
      enemyDeath();
    }
  }

  // Abstract method to allow different enemy death behaviors
  void enemyDeath();

  void facePlayer(double dt) {
    _playerDirection = (game.player.ship.position - position).normalized();
    if (_playerDirection.angleToSigned(direction).abs() > 0.1) {
      changeDirection(_playerDirection.angleToSigned(direction), dt);
    }
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
