import 'package:flutter/material.dart';
import 'package:space_scape/space_game.dart';

class DebugMenuSection extends StatefulWidget {
  final SpaceGame game;

  const DebugMenuSection({
    super.key,
    required this.game,
  });

  @override
  State<DebugMenuSection> createState() => _DebugMenuSectionState();
}

class _DebugMenuSectionState extends State<DebugMenuSection> {
  Widget _buildToggleButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: const BorderSide(color: Color(0xFF4FC3F7)),
          backgroundColor: isEnabled
              ? const Color(0xFF4FC3F7).withAlpha(40)
              : Colors.black26,
        ),
        onPressed: () {
          setState(() {
            onPressed();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            if (isEnabled)
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF4FC3F7),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4FC3F7)),
        color: Colors.black26,
      ),
      child: Column(
        children: [
          const Text(
            'Debug Controls',
            style: TextStyle(color: Color(0xFF4FC3F7), fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildToggleButton(
            text: "Enemy Movement",
            isEnabled: widget.game.isEnemyMovementEnabled,
            onPressed: () => widget.game.toggleEnemyMovement(),
          ),
          _buildToggleButton(
            text: "Enemy Spawn",
            isEnabled: widget.game.isEnemySpawnEnabled,
            onPressed: () => widget.game.toggleEnemySpawn(),
          ),
          _buildToggleButton(
            text: "Player Weapon",
            isEnabled: widget.game.isPlayerWeaponEnabled,
            onPressed: () => widget.game.togglePlayerWeapon(),
          ),
        ],
      ),
    );
  }
}
