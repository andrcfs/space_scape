import '../../space_game.dart';

enum UpgradeType {
  passive,
  active,
  weapon,
  repair;
}

abstract class Upgrade {
  final String name;
  final String description;
  final String icon;
  final UpgradeType upgradeType;
  final Map<String, dynamic> statChanges;
  final int level;

  Upgrade({
    required this.name,
    required this.description,
    required this.icon,
    required this.upgradeType,
    required this.statChanges,
    required this.level,
  });

  void apply(SpaceGame game);

  String getStatsChangeDescription() {
    final List<String> changes = [];

    statChanges.forEach((key, value) {
      switch (key) {
        case 'damage':
          changes.add('Damage +$value');
          break;
        case 'cooldown':
          final reduction = ((1.0 - value) * 100).toInt();
          changes.add('Cooldown -$reduction%');
          break;
        case 'bulletSpeed':
          changes.add('Bullet Speed +$value');
          break;
        case 'bulletAngles':
          changes.add('${(value as List).length} Bullets');
          break;
        case 'penetration':
          changes.add('Penetration +$value');
          break;
        case 'radius':
          final increase = ((value - 1.0) * 100).toInt();
          changes.add('Area +$increase%');
          break;
        case 'health':
          changes.add('Health +$value');
          break;
        case 'shield':
          changes.add('Shield +$value');
          break;
        case 'speed':
          changes.add('Speed +$value');
          break;
        case 'maxHealth':
          changes.add('Max Health +$value');
          break;
        default:
          changes.add('$key: $value');
      }
    });

    return changes.join(', ');
  }
}

class WeaponUpgrade extends Upgrade {
  WeaponUpgrade({
    required super.name,
    required super.description,
    required super.icon,
    required super.statChanges,
    required super.level,
  }) : super(upgradeType: UpgradeType.weapon);

  @override
  void apply(SpaceGame game) {
    final weapon = game.weaponSystem.availableWeapons.firstWhere(
      (element) => element.name == name,
      orElse: () => throw Exception('Weapon $name not found!'),
    );
    if (level == 0) {
      game.weaponSystem.addWeapon(weapon);
    } else if (level < 7) {
      weapon.applyUpgrade(this);
    }
    weapon.removeUpgrade(this);
  }
}

class PlayerStatUpgrade extends Upgrade {
  PlayerStatUpgrade({
    required super.name,
    required super.description,
    required super.icon,
    required super.statChanges,
    required super.level,
    required super.upgradeType,
  });

  @override
  void apply(SpaceGame game) {
    if (statChanges.containsKey('health')) {
      game.player.health.value += statChanges['health'];
      if (game.player.health.value > game.player.maxHealth) {
        game.player.health.value = game.player.maxHealth;
      }
    }
    if (statChanges.containsKey('shield')) {
      game.player.shield.value += statChanges['shield'];
      if (game.player.shield.value > game.player.maxShield) {
        game.player.shield.value = game.player.maxShield;
      }
    }
    if (statChanges.containsKey('maxHealth')) {
      game.player.modifyMaxHealth(statChanges['maxHealth']);
    }
  }
}

class RepairUpgrade extends PlayerStatUpgrade {
  RepairUpgrade({
    required super.name,
    required super.description,
    required super.icon,
    required super.statChanges,
  }) : super(
          level: 0,
          upgradeType: UpgradeType.repair,
        );

  @override
  void apply(SpaceGame game) {
    game.player.health.value = game.player.maxHealth;
  }
}
