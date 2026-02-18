import 'upgrade.dart';

// List of all available passive upgrades
final List<Upgrade> passiveUpgrades = [
  // Energy Shield Level 1
  PlayerStatUpgrade(
    name: 'Energy Shield',
    description: 'Unlock shield that absorbs damage.',
    level: 1,
    upgradeType: UpgradeType.passive,
    icon: 'assets/images/upgrades/shield.png',
    statChanges: {
      'maxShield': 10,
      'shield': 10,
    },
  ),

  // Energy Shield Level 2
  PlayerStatUpgrade(
    name: 'Energy Shield',
    description: 'Increase shield regen and max shield.',
    level: 2,
    upgradeType: UpgradeType.passive,
    icon: 'assets/images/upgrades/shield.png',
    statChanges: {
      'maxShield': 10,
      'shield': 10,
      'regenAmount': 1,
    },
  ),

  // Energy Shield Level 3
  PlayerStatUpgrade(
    name: 'Energy Shield',
    description: 'Reduce shield regeneration cooldown.',
    level: 3,
    upgradeType: UpgradeType.passive,
    icon: 'assets/images/upgrades/shield.png',
    statChanges: {
      'shield': 0, // Will be set to max shield in apply logic
      'shieldRegenCooldown': -3, // Negative value means reduction
    },
  ),

  // Health Upgrade
  PlayerStatUpgrade(
    name: 'Hull Reinforcement',
    description: 'Increase max health of your ship.',
    level: 1,
    upgradeType: UpgradeType.passive,
    icon: 'assets/images/upgrades/health.png',
    statChanges: {
      'maxHealth': 20.0,
      'health': 20.0,
    },
  ),
];
