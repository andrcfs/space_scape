import 'package:flame/components.dart';
import 'package:space_scape/components/ships/ship.dart';
import 'package:space_scape/components/weapons/bullet_weapon.dart';

class BasicShip extends Ship {
  BasicShip(super.player)
      : super(
          size: Vector2(32, 39),
        ) {
    // Initialize health and shield with default values
    health.value = maxHealth;
    shield.value = maxShield;
  }

  @override
  double get maxHealth => 100;

  @override
  double get maxShield => 0;

  @override
  double get regenAmount => 1;

  @override
  double get shieldRegenCooldown => 10;

  @override
  double get acceleration => 65;

  @override
  double get maxSpeed => 75;

  @override
  double get brake => 2;

  @override
  double get turnSpeed => 2;

  @override
  double get collectRadius => 40;

  @override
  BulletWeapon get defaultWeapon => BulletWeapon(player: player);

  @override
  Future<SpriteAnimation> loadShipAnimation() async {
    return await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 39),
      ),
    );
  }
}
