import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_scape/components/enemy.dart';
import 'package:space_scape/components/explosion.dart';
import 'package:space_scape/components/xp.dart';

class AlienCommander extends Enemy {
  static final Vector2 _enemySize = Vector2(39, 41);
  static const double _maxHealth = 10;
  static const double _damage = 1;
  static const double _enemySpeed = 45.5;
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

  AlienCommander({
    super.position,
  }) : super(
          size: _enemySize,
        ) {
    Enemy.damage = _damage;
  }

  @override
  Future<void> loadAnimation() async {
    animation = await game.loadSpriteAnimation(
      'aliencommander.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: .2,
        textureSize: Vector2(39, 41),
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
