// ship_config.dart
import '../weapons/bullet_weapon.dart';
import '../weapons/weapon.dart';

class ShipConfig {
  final String name;
  final double maxHealth;
  final double maxShield;
  final double healthRegen;
  final double shieldRegenCooldown;
  final double acceleration;
  final double maxSpeed;
  final double brakeRatio;
  final double turnSpeed;
  final double collectRadius;
  final String spritePath;
  final Weapon defaultWeapon;

  const ShipConfig({
    required this.name,
    required this.maxHealth,
    required this.maxShield,
    required this.healthRegen,
    required this.shieldRegenCooldown,
    required this.acceleration,
    required this.maxSpeed,
    required this.brakeRatio,
    required this.turnSpeed,
    required this.collectRadius,
    required this.spritePath,
    required this.defaultWeapon,
  });
}

// Ships are now just config constants
class Ships {
  static final basicShip = ShipConfig(
    name: 'Basic Ship',
    maxHealth: 100,
    maxShield: 0,
    healthRegen: 1,
    shieldRegenCooldown: 10,
    acceleration: 65,
    maxSpeed: 75,
    brakeRatio: 0.5,
    turnSpeed: 2,
    collectRadius: 40,
    spritePath: 'player.png',
    defaultWeapon: BulletWeapon(),
  );

  static final advancedShip = ShipConfig(
    name: 'Advanced Ship',
    maxHealth: 150,
    maxShield: 50,
    healthRegen: 2,
    shieldRegenCooldown: 8,
    acceleration: 105,
    maxSpeed: 125,
    brakeRatio: 2.5,
    turnSpeed: 3.5,
    collectRadius: 50,
    spritePath: 'player.png',
    defaultWeapon: BulletWeapon(),
  );
}
