import 'package:flame/game.dart';

import '../entities/ship_config.dart';

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

  MobilityStats.fromShipConfig(ShipConfig shipConfig)
      : maxSpeed = shipConfig.maxSpeed,
        acceleration = shipConfig.acceleration,
        turnSpeed = shipConfig.turnSpeed,
        brakeRatio = shipConfig.brakeRatio {
    deceleration = (-1) * acceleration * brakeRatio;
  }
}
