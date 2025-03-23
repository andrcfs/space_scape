enum UpgradeType {
  passive,
  active,
  weapon,
  repair;
}

class UpgradeLevel {
  final String name;
  final String description;
  final String icon;
  final int level;
  final UpgradeType upgradeType;
  final Map<String, dynamic> statChanges;

  UpgradeLevel({
    required this.name,
    required this.description,
    required this.icon,
    required this.level,
    required this.upgradeType,
    required this.statChanges,
  });

  bool get isMaxLevel => level >= 7; // No more upgrades after level 7

  String getCurrentDescription() {
    return description;
  }

  // Helper method to get formatted description of stat changes
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
        default:
          changes.add('$key: $value');
      }
    });

    return changes.join(', ');
  }
}
