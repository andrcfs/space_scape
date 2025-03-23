/* import '../upgrade.dart';

final energyShieldUpgrade = Upgrade(
  name: 'Energy Shield',
  type: UpgradeType.passive,
  levels: [
    UpgradeLevel(
      description: 'Unlock shield that absorbs damage.',
      apply: (player) {
        player.ship.maxShield += 10;
        player.ship.shield.value = 10;
      },
    ),
    UpgradeLevel(
      description: 'Increase shield regen and max shield.',
      apply: (player) {
        player.ship.regenAmount += 1;
        player.ship.maxShield += 10;
        player.ship.shield.value = player.ship.maxShield;
      },
    ),
    UpgradeLevel(
      description: 'Reduce shield regeneration cooldown.',
      apply: (player) {
        player.ship.shieldRegenCooldown =
            (player.ship.shieldRegenCooldown - 3).clamp(2, double.infinity);
        player.ship.shield.value = player.ship.maxShield;
      },
    ),
  ],
);
 */
