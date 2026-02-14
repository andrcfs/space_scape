import 'package:flame/game.dart';

class MobilityStats {
  double maxSpeed;
  double acceleration;
  double? deceleration;
  double turnSpeed;
  double brakeRatio;
  Vector2 direction = Vector2(0, -1);
  Vector2 velocity = Vector2.zero();
  Vector2? externalForce;

  MobilityStats({
    required this.maxSpeed,
    required this.acceleration,
    required this.turnSpeed,
    required this.brakeRatio,
  }) {
    deceleration = (-1) * acceleration * brakeRatio;
  }
}
