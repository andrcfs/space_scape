import 'entities/ship_config.dart';

class Constitution {
  late double health;
  late double shield;
  double maxHealth;
  double? maxShield = 0;
  double healthRegen;
  double? shieldRegen = 0;
  int healthRegenCooldown;
  int? shieldRegenCooldown;

  double _healthRegenTimer = 0;
  double _shieldRegenTimer = 0;

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

  bool get isAlive => health > 0;

  Constitution.fromShipConfig(ShipConfig shipConfig)
      : maxHealth = shipConfig.maxHealth,
        maxShield = shipConfig.maxShield,
        healthRegen = shipConfig.healthRegen,
        shieldRegen = shipConfig.maxShield > 0 ? shipConfig.healthRegen : 0,
        healthRegenCooldown = shipConfig.healthRegenCooldown,
        shieldRegenCooldown = shipConfig.shieldRegenCooldown,
        health = shipConfig.maxHealth,
        shield = shipConfig.maxShield;

  void update(double dt) {
    // Shield regen logic
    if (maxShield != null && maxShield! > 0) {
      if (_shieldRegenTimer > 0) {
        _shieldRegenTimer -= dt;
      } else if (shield < maxShield!) {
        shield = (shield + (shieldRegen ?? 0) * dt).clamp(0, maxShield!);
      }
    }

    // Health regen logic
    if (_healthRegenTimer > 0) {
      _healthRegenTimer -= dt;
    } else if (health < maxHealth) {
      health = (health + healthRegen * dt).clamp(0, maxHealth);
    }
  }

  void takeDamage(double damage) {
    if (shield > 0) {
      shield = (shield - damage).clamp(0, maxShield ?? 0);
      _shieldRegenTimer = shieldRegenCooldown?.toDouble() ?? 0;
    } else {
      health = (health - damage).clamp(0, maxHealth);
      _healthRegenTimer = healthRegenCooldown.toDouble();
    }
  }

  void modifyMaxHealth(double amount) {
    maxHealth += amount;
    health += amount;
  }

  void modifyMaxShield(double amount) {
    maxShield = (maxShield ?? 0 + amount).clamp(0, double.infinity);
    shield = (shield + amount).clamp(0, maxShield!);
  }
}
