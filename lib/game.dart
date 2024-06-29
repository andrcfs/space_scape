import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:space_scape/components/background.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/player.dart';

final List<LogicalKeyboardKey> keys = [
  LogicalKeyboardKey.arrowUp,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.arrowLeft,
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.keyW,
  LogicalKeyboardKey.keyS,
  LogicalKeyboardKey.keyA,
  LogicalKeyboardKey.keyD,
];

class SpaceGame extends FlameGame
    with
        PanDetector,
        KeyboardEvents,
        HasCollisionDetection,
        HasPerformanceTracker {
  late PlayerShip player;
  late Enemy enemy;
  late List<LogicalKeyboardKey> pressedKeys = [];
  late final TextComponent _componentCounter;
  late final TextComponent _scoreText;
  final Background background = Background();
  double enemySpawnRate = 1;
  double w = 0.0;
  double s = 0.0;
  double a = 0.0;
  double d = 0.0;
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
    addAll([
      Enemy(position: Vector2(size.x / 4, size.y / 2)),
      Enemy(position: Vector2(size.x / 4, size.y / 4)),
      Enemy(position: Vector2(size.x * 3 / 4, size.y * 3 / 4)),
      Enemy(position: Vector2(size.x / 2, size.y / 4))
    ]);
    /* add(SpawnComponent(
      factory: (amount) => Enemy(),
      within: false,
      period: enemySpawnRate,
      area: Circle(Vector2(size.x / 2, size.y / 2), 700),
    )); */
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
    super.onKeyEvent(event, keysPressed);
    if (!isLoaded) {
      return KeyEventResult.ignored;
    }
    pressedKeys.clear();
    for (final key in keysPressed) {
      if (keys.contains(key)) {
        pressedKeys.add(key);
      }
    }
    return KeyEventResult.handled;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move2(info.delta.global);
  }

  void increaseXP() {
    _XP++;
  }
}
