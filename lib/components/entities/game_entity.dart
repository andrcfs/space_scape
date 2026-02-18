import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';

import '../constitution.dart';

abstract class GameEntity extends SpriteAnimationComponent
    with CollisionCallbacks {
  double? healthModifier;
  // Movement related properties
  late final MobilityStats mobilityStats;
  // Health and shield properties
  late final Constitution constitution;
  // Collision hitboxes
  late final RectangleHitbox body;

  GameEntity({
    super.size,
    super.anchor,
    super.position,
    super.angle,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body = RectangleHitbox(isSolid: true);
    add(body);
    add(CircleHitbox(collisionType: CollisionType.active));
  }
}
