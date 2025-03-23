import 'package:flame/components.dart';
import 'package:space_scape/components/player.dart';

import '../../space_game.dart';
import 'weapon.dart';

class WeaponSystem extends Component with HasGameReference<SpaceGame> {
  final Player player;
  final List<Weapon> activeWeapons = [];
  final List<Weapon> availableWeapons = [];

  WeaponSystem(this.player);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Initialize with available weapon templates
    _initializeAvailableWeapons();
    // Add starting weapon based on ship type
    addWeapon(player.ship.defaultWeapon);
  }

  void _initializeAvailableWeapons() {
    //TODO: This should be linked to game progress. This information may be saved in a json file
    availableWeapons.addAll([
      //BulletWeapon(player: player),

      /* AOEWeapon(player: player, radius: 100),
      TurretWeapon(
        player: player, 
        rotationSpeed: 2.0,
        bulletSpeed: 150,
        offset: Vector2(0, -20),
      ), */
      // Add more weapon templates here
    ]);
  }

  void addWeapon(Weapon weapon) {
    activeWeapons.add(weapon);
    availableWeapons.remove(weapon);
    add(weapon);
  }

  // Find a weapon by name from activeWeapons
  Weapon? getWeapon(String weaponName) {
    return activeWeapons.cast<Weapon?>().firstWhere(
          (w) => w?.name == weaponName,
          orElse: () => null,
        );
  }
}
