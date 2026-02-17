import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class DamageNotification extends TextComponent<TextPaint>
    implements OpacityProvider {
  DamageNotification({required double damageAmount, required Vector2 position})
      : super(
          position: position,
          text: '${damageAmount.round()}',
          priority: 100,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 12.0,

              //fontFamily: 'SpaceFont',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.white,
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() {
    add(
      MoveEffect.by(
        Vector2(0, -16),
        EffectController(
          duration: 0.5,
        ),
      ),
    );
    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.5),
      onComplete: removeFromParent,
    ));
  }

  @override
  set opacity(double newValue) {
    textRenderer = textRenderer.copyWith((old) =>
        old.copyWith(color: old.color?.withAlpha((newValue * 255).floor())));
  }

  @override
  get opacity => ((textRenderer.style.color?.a ?? 0) / 255).toDouble();
}
