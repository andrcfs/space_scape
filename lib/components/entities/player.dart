import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:space_scape/components/constitution.dart';
import 'package:space_scape/components/entities/game_entity.dart';
import 'package:space_scape/components/entities/ship_config.dart';
import 'package:space_scape/components/movement/keyboard_movement.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';
import 'package:space_scape/components/weapons/bullet_weapon.dart';

import '../../space_game.dart';
import '../weapons/weapon.dart';
import 'enemy.dart';

class Player extends GameEntity with HasGameReference<SpaceGame> {
  late ShipConfig shipConfig;
  // Health and shield properties

  ValueNotifier<double> currentHealth = ValueNotifier<double>(100);
  ValueNotifier<double> currentShield = ValueNotifier<double>(0);

  double get maxHealth => constitution.maxHealth;
  double get maxShield => constitution.maxShield ?? 0;

  // Weapon configuration
  late Weapon defaultWeapon;
  List<Weapon> weapons = [];

  Player({
    ShipConfig? initialShip,
  }) : super(
          anchor: Anchor.center,
        ) {
    shipConfig = initialShip ?? Ships.basicShip;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = game.size / 2;
    size = shipConfig.size;
    constitution = Constitution.fromShipConfig(shipConfig);
    mobilityStats = MobilityStats.fromShipConfig(shipConfig);
    add(KeyboardMovement());
    animation = await loadShipAnimation();
    defaultWeapon = BulletWeapon();
    weapons.add(defaultWeapon);
    add(defaultWeapon);
    currentHealth.value = maxHealth;
    currentShield.value = maxShield;
  }

  Future<SpriteAnimation> loadShipAnimation() async {
    return await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 39),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) return;
    // Update Health and Shield
    constitution.update(dt);
    // Update ValueNotifiers for HUD
    currentHealth.value = constitution.health;
    currentShield.value = constitution.shield;

    // Check if player died
    if (!constitution.isAlive) {
      game.gameOver = true;
      remove(KeyboardMovement());
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

  void takeDamage(double damage) {
    constitution.takeDamage(damage);
    // Update ValueNotifiers for HUD
    currentHealth.value = constitution.health;
    currentShield.value = constitution.shield;
  }

  void modifyMaxHealth(double amount) {
    constitution.modifyMaxHealth(amount);
    currentHealth.value += amount;
  }

  void modifyMaxShield(double amount) {
    constitution.modifyMaxShield(amount);
    currentShield.value += amount;
  }

  void move2(Vector2 delta) {
    position.add(delta);
  }

  // Method to set or change the player's ship
  /* void setShip(Ship newShip) {
    // Remove previous ship if it exists
    if (parent != null && children.whereType<Ship>().isNotEmpty) {
      final oldShip = children.whereType<Ship>().first;
      weapons.remove(oldShip.defaultWeapon);
      oldShip.removeFromParent();
    }

    ship = newShip;
    add(ship);
    weapons.add(ship.defaultWeapon);
  } */
}
