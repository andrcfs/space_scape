import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:space_scape/components/movement/movement.dart';
import 'package:space_scape/space_game.dart';

class KeyboardMovement extends MovementBehavior
    with HasGameReference<SpaceGame> {
  KeyboardMovement();

  @override
  void update(double dt) {
    thrust(dt);
    move(dt);
    rotate(dt);
  }

  @override
  void move(double delta) {
    if (stats.externalForce != null) {
      //NÃO SEI SE FICA AQUI
      acceleration(delta, stats.externalForce!, stats.acceleration);
    }

    final Vector2 displacement = stats.velocity * delta;
    parentEntity.position += displacement;
  }

  @override
  void rotate(double dt) {
    super.rotate(dt);
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyA) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      parentEntity.angle -= dt * stats.turnSpeed;
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyD) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      parentEntity.angle += dt * stats.turnSpeed;
    }
  }

  void thrust(double delta) {
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyW) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      acceleration(delta, stats.direction, stats.acceleration);
    }
    if (game.pressedKeys.contains(LogicalKeyboardKey.keyS) ||
        game.pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      acceleration(delta, stats.direction, stats.deceleration!);
    }
    if (stats.velocity.length > stats.maxSpeed) {
      stats.velocity = stats.velocity.normalized() * stats.maxSpeed;
    }
  }
}
