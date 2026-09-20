import 'package:flutter/material.dart';

class BoardRenderer {
  static const Color boardWood = Color(0xFF24160E);
  static const Color felt = Color(0xFF382215);
  static const Color triangleLight = Color(0xFFD6B58F);
  static const Color triangleDark = Color(0xFF6E3F27);

  static void drawBoard(Canvas canvas, Size size) {
    final margin = 16.0;
    final w = size.width;
    final h = size.height;

    // ۱. زمینه کلی و نمد کف
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = boardWood);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(margin, margin, w - 2 * margin, h - 2 * margin),
        const Radius.circular(12),
      ),
      Paint()..color = felt,
    );

    // خط حائل وسط (Bar)
    canvas.drawRect(
      Rect.fromLTWH(margin, h / 2 - 35, w - 2 * margin, 70),
      Paint()..color = boardWood,
    );

    // ۲. ۲۴ خانه مثلثی
    final colW = (w - 2 * margin) / 12.0;
    final triH = h * 0.33;

    for (int i = 0; i < 12; i++) {
      final x = margin + i * colW;

      // مثلث‌های بالا
      final topP = Path()
        ..moveTo(x, margin)
        ..lineTo(x + colW, margin)
        ..lineTo(x + colW / 2, margin + triH)
        ..close();
      canvas.drawPath(topP, Paint()..color = (i % 2 == 0) ? triangleLight : triangleDark);

      // مثلث‌های پایین
      final botP = Path()
        ..moveTo(x, h - margin)
        ..lineTo(x + colW, h - margin)
        ..lineTo(x + colW / 2, h - margin - triH)
        ..close();
      canvas.drawPath(botP, Paint()..color = (i % 2 == 0) ? triangleDark : triangleLight);
    }
  }
}
