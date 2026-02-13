import 'package:flame/components.dart';
import 'package:space_scape/components/ships/ship.dart';
import 'package:space_scape/components/weapons/bullet_weapon.dart';

class BasicShip extends Ship {
  double _maxShield = 20;
  double _regenAmount = 1;
  double _shieldRegenCooldown = 10;

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
  double get baseMaxHealth => 100; // Added missing getter implementation

  @override
  double get maxShield => _maxShield;

  @override
  set maxShield(double value) => _maxShield = value;

  @override
  double get regenAmount => _regenAmount;

  @override
  set regenAmount(double value) => _regenAmount = value;

  @override
  double get shieldRegenCooldown => _shieldRegenCooldown;

  @override
  set shieldRegenCooldown(double value) => _shieldRegenCooldown = value;

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
