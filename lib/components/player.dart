import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

import '../space_game.dart';
import 'ships/ship.dart';
import 'weapons/weapon.dart';

class Player extends Component with HasGameReference<SpaceGame> {
  // Reference to the current ship
  late Ship ship;

  // Movement related properties
  Vector2 direction = Vector2(0, -1);
  Vector2 displacement = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  // Ship regeneration properties
  double shieldRegenCurrent = 0;

  // Weapon configuration
  List<Weapon> weapons = [];

  Player();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    ship.position = game.size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) return;

    direction = Vector2(0, -1)..rotate(ship.angle);
    rotate(dt);
    move(dt);

    if (shieldRegenCurrent > 0) shieldRegenCurrent -= dt;
    if (shieldRegenCurrent <= 0 && ship.shield.value < ship.maxShield) {
      ship.shield.value = (ship.shield.value + dt).clamp(0, ship.maxShield);
    }

    if (ship.health.value <= 0) {
      print('Game Over');
      game.gameOver = true;
      velocity = Vector2.zero();
    }
  }

  void rotate(double delta) {
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyA) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      ship.angle -= delta * ship.turnSpeed;
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyD) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      ship.angle += delta * ship.turnSpeed;
    }
  }

  void move(double delta) {
    acceleration(delta);
    displacement = velocity * delta;
    ship.position += displacement;
  }

  void acceleration(double delta) {
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyW) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      velocity += direction.normalized().scaled(ship.acceleration) * delta;
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyS) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      velocity +=
          direction.normalized().scaled(-ship.acceleration / ship.brake) *
              delta;
    }
    if (velocity.length > ship.maxSpeed) {
      velocity = velocity.normalized().scaled(ship.maxSpeed);
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
