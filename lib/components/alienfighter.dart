import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';

class AlienFighter extends Enemy {
  AlienFighter({super.position})
      : super(
          size: Vector2(22, 32),
          maxHealth: Enemy.defaultMaxHealth * 2,
          spritePath: 'alienfighter.png',
          frameCount: 5,
          frameSize: Vector2(22, 32),
          bodySizeFactor: Vector2(0.6, 0.6),
          bodyOffsetFactor: Vector2(0.2, 0.2),
        );
}
