import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';

abstract class GameEntity extends SpriteAnimationComponent {
  double? healthModifier;
  // Movement related properties
  final MobilityStats mobStats;
  GameEntity({
    required this.mobStats,
    super.size,
    super.anchor,
    super.position,
    super.angle,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
  }
}
