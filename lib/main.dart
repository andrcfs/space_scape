import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_scape/game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget.controlled(gameFactory: SpaceGame.new),
    );
  }
}
