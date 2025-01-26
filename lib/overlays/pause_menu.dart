import 'package:flutter/material.dart' hide Action;
import 'package:space_scape/space_game.dart';
import 'package:space_scape/widgets/debug_menu.dart';
import 'package:space_scape/widgets/pause_menu_button.dart';

class PauseMenu extends StatefulWidget {
  final SpaceGame game;
  const PauseMenu(this.game, {super.key});

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  Future<void> _showMainMenuConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0a1128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.amber),
              SizedBox(width: 8),
              Text('Warning', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            'Are you sure you want to go back to the main menu?\nYour progress will be lost.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.game.overlays.remove('PauseMenu');
                widget.game.overlays.add('Menu');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Exit to Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87.withAlpha(100),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color(0xFF1a237e).withAlpha(50),
              Colors.black.withAlpha(50),
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              color: const Color(0xFF0a1128).withAlpha(230),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4FC3F7),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4FC3F7).withAlpha(100),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PAUSED',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.pause_circle_outlined,
                      color: Color(0xFF4FC3F7),
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PauseMenuButton(
                  text: 'Resume',
                  icon: Icons.play_arrow,
                  onPressed: () {
                    widget.game.overlays.remove('PauseMenu');
                    widget.game.paused = false;
                  },
                ),
                PauseMenuButton(
                  text: 'Main Menu',
                  icon: Icons.home,
                  onPressed: _showMainMenuConfirmation,
                ),
                PauseMenuButton(
                  text: 'Restart',
                  icon: Icons.refresh,
                  onPressed: () {
                    // Add restart logic here
                  },
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF4FC3F7)),
                const SizedBox(height: 16),
                // Settings section
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Color(0xFF4FC3F7),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.volume_up,
                      color: Color(0xFF4FC3F7),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF4FC3F7),
                          thumbColor: Colors.white,
                          overlayColor: const Color(0xFF4FC3F7).withAlpha(32),
                        ),
                        child: Slider(
                          value: 0.5, // Replace with actual volume value
                          onChanged: (value) {
                            // Add volume control logic
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.game.debugMode) DebugMenuSection(game: widget.game),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
