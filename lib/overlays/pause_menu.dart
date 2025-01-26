import 'package:flutter/material.dart' hide Action;
import 'package:space_scape/space_game.dart';

class PauseMenu extends StatefulWidget {
  final SpaceGame game;
  const PauseMenu(this.game, {super.key});

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pause menu',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(
                    Icons.pause_circle_outline,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  widget.game.overlays.remove('PauseMenu');
                  widget.game.overlays.add('Menu');
                },
                child: const Text(
                  'Main Screen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                  const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: 'Music volume',
                        child: Icon(
                          Icons.audiotrack_outlined,
                          color: Colors.white,
                        ),
                      ),
                      /* SizedBox(
                        width: MediaQuery.of(context).size.width / 6.5,
                        child: Slider(
                          value: FlameAudio.bgm.audioPlayer.volume,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(
                              () {
                                FlameAudio.bgm.audioPlayer.setVolume(value);
                              },
                            );
                          },
                        ),
                      ),
                      Text(
                        '${(FlameAudio.bgm.audioPlayer.volume * 100).round()}%',
                        style: const TextStyle(color: Colors.white),
                      ), */
                    ],
                  ),
                  if (widget.game.debugMode)
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () => widget.game.toggleEnemyMovement(),
                            child: const Text("Toggle Enemy Movement"),
                          ),
                          OutlinedButton(
                            onPressed: () => widget.game.toggleEnemySpawn(),
                            child: const Text("Toggle Enemy Spawn"),
                          ),
                          OutlinedButton(
                            onPressed: () => widget.game.togglePlayerWeapon(),
                            child: const Text("Toggle Player Weapon"),
                          ),
                        ],
                      ),
                    )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Restart',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.game.overlays.remove('PauseMenu');
                        widget.game.paused = false;
                      },
                      child: const Text(
                        'Resume',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
