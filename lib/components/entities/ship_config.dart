// ship_config.dart
import '../weapons/bullet_weapon.dart';
import '../weapons/weapon.dart';

class ShipConfig {
  final String name;
  final double baseMaxHealth;
  final double maxShield;
  final double regenAmount;
  final double shieldRegenCooldown;
  final double acceleration;
  final double maxSpeed;
  final double brake;
  final double turnSpeed;
  final double collectRadius;
  final String spritePath;
  final Weapon defaultWeapon;

  const ShipConfig({
    required this.name,
    required this.baseMaxHealth,
    required this.maxShield,
    required this.regenAmount,
    required this.shieldRegenCooldown,
    required this.acceleration,
    required this.maxSpeed,
    required this.brake,
    required this.turnSpeed,
    required this.collectRadius,
    required this.spritePath,
    required this.defaultWeapon,
  });
}

// Ships are now just config constants
class ShipConfigs {
  static final basicShip = ShipConfig(
    name: 'Basic Ship',
    baseMaxHealth: 100,
    maxShield: 0,
    regenAmount: 1,
    shieldRegenCooldown: 10,
    acceleration: 65,
    maxSpeed: 75,
    brake: 2,
    turnSpeed: 2,
    collectRadius: 40,
    spritePath: 'player.png',
    defaultWeapon: BulletWeapon(),
  );

  static final advancedShip = ShipConfig(
    name: 'Advanced Ship',
    baseMaxHealth: 150,
    maxShield: 50,
    regenAmount: 2,
    shieldRegenCooldown: 8,
    acceleration: 55,
    maxSpeed: 85,
    brake: 1.5,
    turnSpeed: 2.5,
    collectRadius: 50,
    spritePath: 'advanced_player.png',
    defaultWeapon: BulletWeapon(),
  );
}
