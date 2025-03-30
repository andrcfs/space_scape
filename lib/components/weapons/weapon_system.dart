import 'package:flame/components.dart';
import 'package:space_scape/components/player.dart';

import '../../space_game.dart';
import 'bullet_weapon.dart';
import 'coronal_discharge_weapon.dart';
import 'weapon.dart';

class WeaponSystem extends Component with HasGameReference<SpaceGame> {
  final Player player;
  final List<Weapon> activeWeapons = [];
  final Set<Weapon> unlockedWeapons = {};

  WeaponSystem(this.player);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // First add starting weapon based on ship type

    // Then initialize other unlocked weapons
    _initializeUnlockedWeapons();
    addWeapon(player.ship.defaultWeapon);
  }

  void _initializeUnlockedWeapons() {
    //TODO: This should be linked to game progress. This information may be saved in a json file
    final weapons = [
      BulletWeapon(player: player),
      CoronalDischargeWeapon(player: player),
      /*
      TurretWeapon(
        player: player, 
        rotationSpeed: 2.0,
        bulletSpeed: 150,
        offset: Vector2(0, -20),
      ), */
      // Add more weapon templates here
    ];

    unlockedWeapons.addAll(weapons);
  }

  void addWeapon(Weapon weapon) {
    activeWeapons.add(weapon);
    unlockedWeapons.removeWhere((w) => w.name == weapon.name);
    player.ship.add(weapon);
  }
}
