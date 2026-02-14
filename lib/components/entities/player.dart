import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_scape/components/entities/game_entity.dart';
import 'package:space_scape/components/movement/keyboard_movement.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';

import '../../space_game.dart';
import '../ships/ship.dart';
import '../weapons/weapon.dart';

class Player extends GameEntity with HasGameReference<SpaceGame> {
  // Reference to the current ship
  late Ship ship;

  // Ship regeneration properties
  double shieldRegenCurrent = 0;

  // Weapon configuration
  List<Weapon> weapons = [];

  // Movement properties
  MobilityStats mobilityStats;

  Player({required this.mobilityStats})
      : super(
          mobStats: mobilityStats,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    ship.position = game.size / 2;
    add(KeyboardMovement());
  }

  @override
  void update(double dt) {
    if (game.gameOver) return;

    if (shieldRegenCurrent > 0) shieldRegenCurrent -= dt;
    if (shieldRegenCurrent <= 0 && ship.shield.value < ship.maxShield) {
      ship.shield.value = (ship.shield.value + dt).clamp(0, ship.maxShield);
    }

    if (ship.health.value <= 0) {
      game.gameOver = true;
      mobilityStats.velocity = Vector2.zero();
    }
  }

  void move2(Vector2 delta) {
    ship.position.add(delta);
  }

  // Method to set or change the player's ship
  void setShip(Ship newShip) {
    // Remove previous ship if it exists
    if (parent != null && children.whereType<Ship>().isNotEmpty) {
      final oldShip = children.whereType<Ship>().first;
      weapons.remove(oldShip.defaultWeapon);
      oldShip.removeFromParent();
    }

    ship = newShip;
    add(ship);
    weapons.add(ship.defaultWeapon);
  }
}
