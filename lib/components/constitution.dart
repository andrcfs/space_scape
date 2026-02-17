import 'entities/ship_config.dart';

class Constitution {
  late double health;
  late double shield;
  double maxHealth;
  double? maxShield = 0;
  double healthRegen;
  double? shieldRegen = 0;
  double healthRegenCooldown;
  double? shieldRegenCooldown = 0;

  Constitution({
    required this.maxHealth,
    this.maxShield,
    required this.healthRegen,
    this.shieldRegen,
    required this.healthRegenCooldown,
    this.shieldRegenCooldown,
  }) {
    health = maxHealth;
    shield = maxShield ?? 0;
  }

  Constitution.fromShipConfig(ShipConfig shipConfig)
      : maxHealth = shipConfig.maxHealth,
        maxShield = shipConfig.maxShield,
        healthRegen = shipConfig.healthRegen,
        shieldRegen = shipConfig.maxShield > 0 ? shipConfig.healthRegen : 0,
        healthRegenCooldown = 1.0,
        shieldRegenCooldown = shipConfig.shieldRegenCooldown;
}
