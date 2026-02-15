import 'package:flame/components.dart';
import 'package:space_scape/components/entities/game_entity.dart';
import 'package:space_scape/components/movement/mobility_stats.dart';

abstract class MovementBehavior extends Component {
  late GameEntity parentEntity;
  late final MobilityStats stats;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (parent is! GameEntity) {
      throw Exception(
          'MovementBehavior can only be added to GameEntity components.');
    }
    parentEntity = parent as GameEntity;
    stats = parentEntity.mobStats;
  }

  void move(double delta);

  void acceleration(double delta, Vector2 direction, double scalar) {
    // Apply acceleration to velocity
    stats.velocity += direction.normalized() * scalar * delta;
  }

  void rotate(double dt) {
    stats.direction = Vector2(0, -1)..rotate(parentEntity.angle);
  }

  void stop() {
    stats.velocity = Vector2.zero();
  }
}
