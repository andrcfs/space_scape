import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:space_scape/components/background.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/player.dart';

class SpaceGame extends FlameGame
    with
        PanDetector,
        KeyboardEvents,
        HasCollisionDetection,
        HasPerformanceTracker {
  late PlayerShip player;
  late final TextComponent _componentCounter;
  late final TextComponent _scoreText;
  final Background background = Background();
  final enemySpawnRate = 0.5;
  double x = 0.0;
  double y = 0.0;
  int _XP = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      _scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      _componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 2),
    );
    add(background);
    add(parallax);
    player = PlayerShip();
    camera.follow(player);
    add(player);
    add(SpawnComponent(
      factory: (amount) => Enemy(),
      period: enemySpawnRate,
      area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = 'XP: $_XP';
    _componentCounter.text = 'Components: ${children.length}';
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      x = -10;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      x = 10;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      y = -10;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      y = 10;
    }
    if (x != 0 && y != 0) {
      player.move(Vector2(x / sqrt(2), y / sqrt(2)));
    } else {
      player.move(Vector2(x, y));
    }
    x = 0.0;
    y = 0.0;
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  void increaseXP() {
    _XP++;
  }
}
