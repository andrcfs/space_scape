import 'package:flame_audio/flame_audio.dart';
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
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pause_circle_outline),
          const Text('Pause menu'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
              Text('Settings', style: Theme.of(context).textTheme.titleMedium),
              ListTile(
                leading: const Tooltip(
                    message: 'Music volume',
                    child: Icon(Icons.audiotrack_outlined)),
                title: Slider(
                    value: FlameAudio.bgm.audioPlayer.volume,
                    onChanged: (value) {
                      setState(() {
                        FlameAudio.bgm.audioPlayer.setVolume(value);
                      });
                    }),
                trailing: Text(
                    '${(FlameAudio.bgm.audioPlayer.volume * 100).round()}%'),
              )
            ],
          ),
          TextButton(onPressed: () {}, child: const Text('Restart')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Main Screen'),
          ),
          TextButton(
            onPressed: () {
              widget.game.paused = false;
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}
