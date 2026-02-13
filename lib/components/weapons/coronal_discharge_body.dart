import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../enemy.dart';

class CoronalDischargeBody extends CircleComponent with CollisionCallbacks {
  double damage;
  double pushForce;
  late CircleHitbox hitbox;

  CoronalDischargeBody({
    required double radius,
    required this.damage,
    required this.pushForce,
    super.position,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          priority: 1000,
          paint: Paint()
            ..color = const Color.fromARGB(132, 0, 140, 255)
            ..style = PaintingStyle.fill
            ..strokeWidth = 2.0,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Position the hitbox at the center of the component (0,0)
    // rather than using the component's position
    hitbox = CircleHitbox(
      radius: radius,
      position: position,
      isSolid: true,
      collisionType: CollisionType.active,
    );
    add(hitbox);
  }

  void applyDamage() {
    if (hitbox.activeCollisions.isEmpty) return;
    for (var collision in hitbox.activeCollisions) {
      if (collision.collisionType == CollisionType.passive) {
        final object = collision.hitboxParent;
        if (object is Enemy) {
          object.takeDamage(damage, pushForce);
        }
      }
    }
  }

  void updateRadius(double newRadius) {
    radius = newRadius;
    if (hasChildren) {
      remove(hitbox);
      hitbox = CircleHitbox(
          radius: newRadius,
          position: Vector2.zero(),
          isSolid: true,
          collisionType: CollisionType.active);
      add(hitbox);
    }
  }
}
