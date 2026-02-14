import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';

abstract class GameEntity extends PositionComponent {
  GameEntity({
    required this.mobStats,
    this.animation,
  });

  // Movement related properties
  final MobilityStats mobStats;

  final SpriteAnimation? animation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
  }
}
