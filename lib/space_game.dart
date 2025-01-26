import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/player.dart';
import 'package:space_scape/components/xp.dart';

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
  SpaceGame({required super.world});

  late PlayerShip player;
  late Enemy enemy;
  late int enemyACap = 30;
  late CameraComponent playerCamera;
  late List<LogicalKeyboardKey> pressedKeys = [];
  late final TextComponent _componentCounter;
  late final TextComponent _scoreText;
  late final TextComponent _lvlText;
  late SpawnComponent spawnEnemyA;

  final double _updateInterval = .1;
  double _updateTimer = 0.0;
  bool gameOver = true;
  bool isTest = false;
  double enemySpawnRate = 0.5;
  double w = 0.0;
  double s = 0.0;
  double a = 0.0;
  double d = 0.0;
  int enemyCount = 0;
  int xp = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = PlayerShip();
    world.add(player);

    //CAMERA AND UI

    camera.follow(player);
    camera.viewport.addAll([
      FpsTextComponent(
        position: size - Vector2(0, 75),
        anchor: Anchor.bottomRight,
      ),
      _lvlText = TextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      _scoreText = TextComponent(
        text: 'XP: $xp',
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

    //ENEMY SPAWN

    spawnEnemyA = SpawnComponent(
      factory: (amount) => Enemy(),
      within: false,
      autoStart: false,
      period: enemySpawnRate,
      area: Circle(
          Vector2(camera.viewport.virtualSize.x / 2,
              camera.viewport.virtualSize.y / 2),
          1000),
    );
    world.add(spawnEnemyA);
  }

  @override
  void update(double dt) {
    super.update(dt);
    enemyCount = world.children.whereType<Enemy>().length;
    _scoreText.text = 'XP: $xp';
    _lvlText.text = 'Level: ${player.levelSystem.currentLevel}';
    _componentCounter.text = 'Enemies: $enemyCount';
    _updateTimer += dt;
    if (_updateTimer >= _updateInterval) {
      _updateTimer = 0.0;
      if (enemyCount >= enemyACap) {
        spawnEnemyA.timer.stop();
      } else if (!spawnEnemyA.timer.isRunning() && !gameOver) {
        spawnEnemyA.timer.start();
      }
      spawnEnemyA.area =
          Circle(Vector2(player.position.x, player.position.y), 1000);
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    if (!isLoaded || gameOver) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape &&
        event is KeyDownEvent) {
      if (overlays.isActive('PauseMenu')) {
        overlays.remove('PauseMenu');
      } else {
        overlays.add('PauseMenu');
      }
      paused = !paused;
      return KeyEventResult.handled;
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

  void toggleEnemyMovement() {
    Enemy.hasMovement = !Enemy.hasMovement;
  }

  void togglePlayerWeapon() {
    if (player.bulletCreator.timer.isRunning()) {
      player.bulletCreator.timer.stop();
    } else {
      player.bulletCreator.timer.start();
    }
  }

  void toggleEnemySpawn() {
    if (spawnEnemyA.timer.isRunning()) {
      spawnEnemyA.timer.stop();
    } else {
      spawnEnemyA.timer.start();
    }
  }

  void givePlayerXp() {
    player.levelSystem.addXP(1);
    xp = player.levelSystem.currentXP;
  }

  void startGame() {
    gameOver = false;
    overlays.add('PlayerUI');
    xp = 0;
    spawnEnemyA.timer.start();
    player.bulletCreator.timer.start();
    world.addAll([
      XP(position: Vector2(size.x * 0.4, size.y / 2)),
      Enemy(position: Vector2(size.x + 10, -size.y / 6)),
      Enemy(position: Vector2(-size.x / 6, -size.y / 6)),
      Enemy(position: Vector2(size.x + 20, size.y * 1 / 2 - 200)),
      Enemy(position: Vector2(size.x / 2, size.y + 10)),
      Enemy(position: Vector2(-10, size.y / 2 + 300)),
      Enemy(position: Vector2(size.x / 2 + 150, -20)),
      Enemy(position: Vector2(size.x / 2 - 300, -20)),
      /* Enemy(position: Vector2(size.x - 160, size.y - 150)),
      Enemy(position: Vector2(size.x - 140, size.y - 150)),
      Enemy(position: Vector2(size.x - 150, size.y - 150)),
      Enemy(position: Vector2(size.x - 175, size.y - 199)), */
    ]);
  }

  void startTest() {
    gameOver = false;
    isTest = true;
    debugMode = true;
    overlays.add('PlayerUI');
    xp = 0;
    world.addAll([
      XP(
        position: Vector2(size.x * 0.4, size.y / 2),
      ),
      Enemy(position: Vector2(size.x * 0.3, size.y * 0.5)),
      Enemy(position: Vector2(-size.x * 0.3, size.y * 0.4)),
      Enemy(position: Vector2(size.x * 0.35, size.y * 0.45)),
      Enemy(position: Vector2(size.x * 0.37, size.y * 0.4)),
      Enemy(position: Vector2(size.x * 0.4, size.y * 0.4)),
      Enemy(position: Vector2(size.x * 0.3, size.y * 0.3)),
      /* Enemy(position: Vector2(size.x - 160, size.y - 150)),
      Enemy(position: Vector2(size.x - 140, size.y - 150)),
      Enemy(position: Vector2(size.x - 150, size.y - 150)),
      Enemy(position: Vector2(size.x - 175, size.y - 199)), */
    ]);
    Enemy.hasMovement = !Enemy.hasMovement;
  }
}
