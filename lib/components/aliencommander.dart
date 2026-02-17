import 'package:flame/components.dart';
import 'package:space_scape/components/alienfighter.dart';
import 'package:space_scape/components/enemy.dart';

class AlienCommander extends Enemy {
  AlienCommander({super.position})
      : super(
          size: Vector2(30, 39),
          maxHealth: Enemy.defaultMaxHealth * 4,
          spritePath: 'aliencommander.png',
          frameCount: 4,
          frameSize: Vector2(30, 39),
          bodySizeFactor: Vector2(0.6, 0.6),
          bodyOffsetFactor: Vector2(0.2, 0.2),
        ) {
    enemySpeed *= 2;
  }
}
