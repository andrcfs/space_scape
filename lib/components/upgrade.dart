import 'player.dart';

enum UpgradeType { weapon, passive, active }

class Upgrade {
  final String name;
  final UpgradeType type;
  final List<UpgradeLevel> levels;
  int currentLevel = 0;

  Upgrade({required this.name, required this.levels, required this.type});

  bool get isMaxLevel => currentLevel >= levels.length;
  int get maxLevel => levels.length;

  String getCurrentDescription() {
    return levels[currentLevel].description;
  }

  void apply(PlayerShip player) {
    if (!isMaxLevel) {
      levels[currentLevel].apply(player);
      currentLevel++;
    }
  }
}

class UpgradeLevel {
  final String description;
  final Function(PlayerShip) apply;

  UpgradeLevel({required this.description, required this.apply});
}

final upgradesList = [
  Upgrade(
    name: 'Basic Shot',
    type: UpgradeType.weapon,
    levels: upgradeLevelsMap['Basic Shot']!,
  ),
  Upgrade(
    name: 'Eletric Discharge',
    type: UpgradeType.weapon,
    levels: [],
  ),
  Upgrade(
      name: 'Coronal Discharge',
      levels: [],
      type: UpgradeType
          .weapon), //Eletric discharges around the player does AOE damage

  Upgrade(
      name: 'Seimic Charge',
      levels: [],
      type: UpgradeType.weapon), //A bomb that does AOE damage
  Upgrade(
      name: 'Missile Launcher',
      levels: [],
      type: UpgradeType.weapon), //Fires homing missiles
  Upgrade(
      name: 'Laser Beam',
      levels: [],
      type: UpgradeType.weapon), //A beam that does damage over time
  Upgrade(
      name: 'Auto-turret',
      levels: [],
      type: UpgradeType.weapon), //A turret that shoots at nearest enemies
  Upgrade(
      name: 'Flame Thrower',
      levels: [],
      type:
          UpgradeType.weapon), //A flame thrower that does AOE damage over time
  /* Upgrade(name: 'Gauss Cannon', levels: [], type: UpgradeType.weapon),
  Upgrade(name: 'Plasma Cannon', levels: [], type: UpgradeType.weapon),
  Upgrade(name: 'Ion Cannon', levels: [], type: UpgradeType.weapon), */
  Upgrade(
      name: 'Yamato Cannon',
      levels: [],
      type: UpgradeType.weapon), //Special charged shot that does massive damage
  Upgrade(
      name: 'EMP',
      levels: [],
      type: UpgradeType.active), //Special ability that stuns enemies
  Upgrade(
      name: 'Nuke',
      levels: [],
      type: UpgradeType.active), //Special ability that does massive damage
  Upgrade(
      name: 'Black Hole',
      levels: [],
      type: UpgradeType
          .active), //Special ability that shoots a blackhole that sucks enemies
  Upgrade(
      name: 'Time Warp',
      levels: [],
      type: UpgradeType.active), //Special ability that slows down time
  Upgrade(
      name: 'Teleport',
      levels: [],
      type: UpgradeType.active), //Special ability that teleports the player
  Upgrade(
    name: 'Energy Shield',
    type: UpgradeType.passive,
    levels: upgradeLevelsMap['Energy Shield']!,
  ),
  Upgrade(
    name: 'Engine Upgrade',
    type: UpgradeType.passive,
    levels: upgradeLevelsMap['Engine Upgrade']!,
  ),
  Upgrade(
    name: 'Repair bots',
    type: UpgradeType.active,
    levels: upgradeLevelsMap['Repair bots']!,
  ),
];

final Map<String, List<UpgradeLevel>> upgradeLevelsMap = {
  'Basic Shot': [
    UpgradeLevel(
      description: 'Increase attack speed and damage.',
      apply: (player) {
        player.attackSpeed *= 1.2;
      },
    ),
    UpgradeLevel(
      description: 'Increase Spread Shot bullet speed by 50.',
      apply: (player) {
        player.bulletSpeed += 50;
      },
    ),
    UpgradeLevel(
      description: 'Increase Spread Shot fire rate by 20%.',
      apply: (player) {
        player.attackSpeed *= 1.2;
      },
    ),
    UpgradeLevel(
      description: 'Fires 2 more aditional bullets with spread each shot.',
      apply: (player) {
        player.bulletAngles.addAll([-0.2, 0.2]);
      },
    ),
  ],
  'Energy Shield': [
    UpgradeLevel(
      description:
          'Unlock a shield that absorbs damage and regens when not taking damage.',
      apply: (player) {
        player.maxShield += 10;
        player.shield.value = 10;
      },
    ),
    UpgradeLevel(
      description: 'Increase shield regeneration rate and max shield.',
      apply: (player) {
        player.regenAmount += 1;
        player.maxShield += 10;
        player.shield.value = player.maxShield;
      },
    ),
    UpgradeLevel(
      description: 'Reduce shield regeneration cooldown.',
      apply: (player) {
        player.shieldRegenCooldown =
            (player.shieldRegenCooldown - 3).clamp(2, double.infinity);
        player.shield.value = player.maxShield;
      },
    ),
  ],
  'Engine Upgrade': [
    UpgradeLevel(
      description: 'Increase max speed.',
      apply: (player) {
        player.maxSpeed *= 1.2;
      },
    ),
    UpgradeLevel(
      description: 'Improve acceleration and maneuverability.',
      apply: (player) {
        player.acc *= 1.2;
        player.brake *= 0.8;
        player.turnSpeed *= 1.2;
      },
    ),
    UpgradeLevel(
      description: 'Increase max speed.',
      apply: (player) {
        player.maxSpeed *= 1.2;
      },
    ),
  ],
  'Repair bots': [
    UpgradeLevel(
      description: 'Automated bots that repair your ship.',
      apply: (player) {
        player.health.value = player.maxHealth;
      },
    ),
  ],
};
