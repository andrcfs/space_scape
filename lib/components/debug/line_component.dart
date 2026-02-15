import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LineComponent extends Component {
  // Start and end points of the line
  final Vector2 start;
  final Vector2 end;
  final Paint paint;

  LineComponent({
    required this.start,
    required this.end,
    Color color = Colors.blue,
    double strokeWidth = 2.0,
  }) : paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the line on the canvas
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }
}
