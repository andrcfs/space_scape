import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/components/background.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/space_game.dart';

class Map1 extends World with HasGameReference<SpaceGame> {
  late Enemy enemy;
  late int enemyACap = 30;
  double _updateTimer = 0.0;
  final double _updateInterval = .1;

  late ParallaxComponent parallax;
  final Background background = Background();
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    //BACKGROUND

    parallax = await game.loadParallaxComponent(
      [
        ParallaxImageData('stars_2.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_0.png'),
      ],
      baseVelocity: Vector2(0, 0),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0.3, 0.3),
    );
    game.camera.backdrop.add(parallax);
    //game.camera.backdrop.add(background);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateTimer += dt;
    if (_updateTimer >= _updateInterval) {
      _updateTimer = 0.0;
      parallax.parallax?.baseVelocity = game.player.velocity;
    }
  }
}
