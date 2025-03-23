import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import '../../space_game.dart';
import '../enemy.dart';
import '../explosion.dart';
import '../player.dart';
import '../weapons/weapon.dart';
import '../xp.dart';

abstract class Ship extends SpriteAnimationComponent
    with HasGameReference<SpaceGame>, CollisionCallbacks {
  final Player player;

  Ship(this.player, {required Vector2 size})
      : super(size: size, anchor: Anchor.center);

  // Ship stats - will be defined by specific ship implementations
  ValueNotifier<double> health = ValueNotifier<double>(100);
  ValueNotifier<double> shield = ValueNotifier<double>(0);

  double iTimeLeft = 0;
  static const double iTime = 0.1;

  // These should be overridden by concrete implementations
  double get maxHealth;
  double get maxShield;
  double get regenAmount;
  double get shieldRegenCooldown;
  double get acceleration;
  double get maxSpeed;
  double get brake;
  double get turnSpeed;
  double get collectRadius;

  // Each ship can have its own starting weapons
  Weapon get defaultWeapon;

  // Ship components
  late final RectangleHitbox body;
  late final CircleHitbox collectRadiusHitbox;

  @override
  Future<void> onLoad() async {
    body = RectangleHitbox(isSolid: true);
    add(body);

    collectRadiusHitbox = CircleHitbox(
      radius: collectRadius,
      position:
          -Vector2(collectRadius - size.x * 0.5, collectRadius - size.y * 0.5),
      isSolid: true,
    );
    add(collectRadiusHitbox);

    // Load the ship's sprite animation - each ship will implement this
    animation = await loadShipAnimation();

    await super.onLoad();
  }

  // Abstract method to load ship-specific animation
  Future<SpriteAnimation> loadShipAnimation();

  void takeHit(double damage) {
    if (shield.value > 0) {
      iTimeLeft = iTime;
      player.shieldRegenCurrent = shieldRegenCooldown;
      shield.value = (shield.value - damage).clamp(0, maxShield);
    } else {
      iTimeLeft = iTime;
      game.world.add(Explosion(position: position, size: Vector2.all(20)));
      health.value = (health.value - damage).clamp(0, maxHealth);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy && body.collidingWith(other.hitbox)) {
      if (iTimeLeft <= 0) takeHit(Enemy.damage);
    }
    if (other is XP) {
      if (game.gameOver) return;
      other.moveToPlayer();
      if (body.collidingWith(other.hitbox)) {
        game.levelSystem.addXP(1);
        game.xp = game.levelSystem.currentXP;
        other.removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (iTimeLeft > 0) iTimeLeft -= dt;

    // Ship-specific update logic can be added in subclasses
  }
}
