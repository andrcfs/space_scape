import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_scape/components/entities/enemy.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/objects/xp.dart';

class BasicEnemy extends Enemy {
  static const double _enemySize = 24.0;
  static const double _maxHealth = 5;
  static const double _damage = 1;
  static const double _enemySpeed = 35.0;
  static const double _turnSpeed = 1.5;
  static const int _xpDropRate = 50;

  @override
  double get enemySpeed => _enemySpeed;

  @override
  double get turnSpeed => _turnSpeed;

  @override
  double get maxHealth => _maxHealth;

  @override
  int get xpDropRate => _xpDropRate;

  BasicEnemy({
    super.position,
  }) : super(
          size: Vector2.all(_enemySize),
        ) {
    Enemy.damage = _damage;
  }

  @override
  Future<void> loadAnimation() async {
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );
  }

  @override
  void enemyDeath() {
    game.world.add(Explosion(position: position, size: Vector2.all(50)));
    if (Random().nextInt(100) < xpDropRate) {
      game.world.add(XP(position: position));
    }
    removeFromParent();
  }
}
