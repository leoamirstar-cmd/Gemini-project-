import 'dart:math';
import 'package:flutter/material.dart';

class DiceRenderer {
  static void drawDice(Canvas canvas, Offset center, int value) {
    final boxPaint = Paint()..color = const Color(0xFFFAF9F6);
    final dotPaint = Paint()..color = const Color(0xFF1E140E);

    // جعبه مکعبی تاس
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 52, height: 52),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, boxPaint);

    // چاپ عدد تاس وسط آن با فونت شیک
    final painter = TextPainter(
      text: TextSpan(
        text: "$value",
        style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(center.dx - painter.width / 2, center.dy - painter.height / 2));
  }

  static List<int> roll() {
    final rng = Random();
    final d1 = rng.nextInt(6) + 1;
    final d2 = rng.nextInt(6) + 1;
    return (d1 == d2) ? [d1, d1, d1, d1] : [d1, d2];
  }
}
