/* import '../upgrade.dart';

final Upgrade basicShotUpgrade = Upgrade(
  name: 'Basic Shot',
  type: UpgradeType.weapon,
  levels: [
    UpgradeLevel(
      description: 'Increase damage.', //##TODO DAMAGE
      apply: (player) => player.attackSpeed *= 1.2,
    ),
    UpgradeLevel(
      description: 'Increase bullet speed by 50.',
      apply: (player) => player.bulletSpeed += 50,
    ),
    UpgradeLevel(
      description: 'Increase fire rate by 20%.',
      apply: (player) => player.attackSpeed *= 1.2,
    ),
    UpgradeLevel(
      description: 'Choose your shot enhancement',
      apply: (player) {},
      choices: [
        UpgradeLevel(
          description: 'Double Shot - Fire 2 bullets',
          apply: (player) {
            player.bulletAngles.clear();
            player.bulletAngles.addAll([-0.1, 0.1]);
          },
        ),
        UpgradeLevel(
          description: 'Rapid Fire - Double attack speed',
          apply: (player) => player.attackSpeed *= 2.0,
        ),
      ],
    ),
    UpgradeLevel(
      description: 'Increase damage.',
      apply: (player) => player.attackSpeed *= 1.2,
    ),
    UpgradeLevel(
      description: 'Shared buff for all choices',
      apply: (player) => player.attackSpeed *= 1.1,
    ),
    UpgradeLevel(
      description: 'Conditional final upgrade',
      apply: (player) {
        if (basicShotUpgrade.choicesTaken
            .contains('Double Shot - Fire 2 bullets')) {
          player.attackSpeed *= 1.3;
        } else if (basicShotUpgrade.choicesTaken
            .contains('Rapid Fire - Double attack speed')) {
          player.bulletSpeed += 100;
        }
      },
    ),
    UpgradeLevel(
      description: null,
      dynamicDescription: (upgrade) {
        if (upgrade.choicesTaken.contains('Double Shot - Fire 2 bullets')) {
          return 'Improve attack rate further';
        } else if (upgrade.choicesTaken
            .contains('Rapid Fire - Double attack speed')) {
          return 'Boost bullet speed even more';
        }
        return 'Final upgrade unlocked';
      },
      apply: (player) {
        // ...existing code...
      },
    ),
  ],
);
 */
