import 'package:flutter/material.dart';

class PieceRenderer {
  static const Color whitePiece = Color(0xFFF9F6F0);
  static const Color blackPiece = Color(0xFF1A1A1A);
  static const Color goldBorder = Color(0xFFD4AF37);
  static const Color silverBorder = Color(0xFF707070);

  static void drawPieces(Canvas canvas, Size size, List<int> points) {
    final margin = 16.0;
    final colW = (size.width - 2 * margin) / 12.0;
    final radius = colW * 0.44;

    for (int idx = 0; idx < 24; idx++) {
      final count = points[idx];
      if (count == 0) continue;

      final isWhite = count > 0;
      final isTop = idx >= 12;
      final col = isTop ? (idx - 12) : (11 - idx);
      final cx = margin + col * colW + colW / 2;
      final total = count.abs();

      for (int p = 0; p < total; p++) {
        final cy = isTop
            ? (margin + radius + p * (radius * 1.7))
            : ((size.height - margin) - radius - p * (radius * 1.7));

        final center = Offset(cx, cy);
        canvas.drawCircle(center, radius, Paint()..color = isWhite ? whitePiece : blackPiece);
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = isWhite ? goldBorder : silverBorder
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
      }
    }
  }
}
