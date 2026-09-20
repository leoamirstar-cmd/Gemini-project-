import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../components/board_component.dart';
import '../components/piece_component.dart';
import '../components/dice_component.dart';

class PassAndPlayScreen extends StatefulWidget {
  const PassAndPlayScreen({super.key});

  @override
  State<PassAndPlayScreen> createState() => _PassAndPlayScreenState();
}

class _PassAndPlayScreenState extends State<PassAndPlayScreen> {
  final GameState state = GameState();
  bool canRoll = true;
  String infoText = "برای شروع، تاس بریزید";

  void _rollDice() {
    if (!canRoll) return;

    setState(() {
      final rolled = DiceRenderer.roll();
      state.dice = List.from(rolled);
      canRoll = false;
      final turn = state.isWhiteTurn ? "سفید" : "سیاه";
      infoText = "نوبت: $turn | تاس: ${state.dice.join(' و ')}";
    });
  }

  void _endTurn() {
    setState(() {
      state.isWhiteTurn = !state.isWhiteTurn;
      state.dice.clear();
      state.selectedPoint = null;
      state.validMoves.clear();
      canRoll = true;
      final turn = state.isWhiteTurn ? "سفید" : "سیاه";
      infoText = "نوبت: $turn | برای پرتاب تاس لمس کنید";
    });
  }

  // محاسبه اینکه کاربر کجای تخته را لمس کرده است
  void _handleBoardTap(Offset localPos, Size boardSize) {
    if (state.dice.isEmpty) return;

    final margin = 16.0;
    final colW = (boardSize.width - 2 * margin) / 12.0;

    if (localPos.dx < margin || localPos.dx > boardSize.width - margin) return;

    final colIndex = ((localPos.dx - margin) / colW).floor().clamp(0, 11);
    final isTop = localPos.dy < boardSize.height / 2;

    // تبدیل مختصات لمس صفحه به ایندکس خانه بین ۰ تا ۲۳
    final pointIndex = isTop ? (12 + colIndex) : (11 - colIndex);

    setState(() {
      // اگر کاربر روی یکی از مقصدهای مجاز سبز لمس کرد، حرکت انجام شود
      if (state.selectedPoint != null && state.validMoves.contains(pointIndex)) {
        state.makeMove(state.selectedPoint!, pointIndex);
        if (state.dice.isEmpty) {
          _endTurn(); // اگر تاس‌ها تمام شد نوبت بعدی
        } else {
          final turn = state.isWhiteTurn ? "سفید" : "سیاه";
          infoText = "نوبت: $turn | تاس باقی‌مانده: ${state.dice.join(' و ')}";
        }
      } else {
        // در غیر این صورت، ستون مهره لمس‌شده را انتخاب کن
        state.selectPoint(pointIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E140E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF24160E),
        elevation: 0,
        title: const Text('تخته نرد (دو نفره محلی)', style: TextStyle(color: Colors.amber, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // نوار وضعیت
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF2E1C12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  infoText,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _endTurn,
                  child: const Text('پایان نوبت', style: TextStyle(color: Colors.amberAccent)),
                ),
              ],
            ),
          ),

          // میز بازی و تشخیص لمس مستقیم
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boardSize = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  onTapDown: (details) => _handleBoardTap(details.localPosition, boardSize),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: boardSize,
                        painter: InteractiveBoardPainter(
                          points: state.points,
                          dice: state.dice,
                          selectedPoint: state.selectedPoint,
                          validMoves: state.validMoves,
                        ),
                      ),

                      if (canRoll)
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[700],
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: _rollDice,
                            icon: const Icon(Icons.casino),
                            label: const Text('پرتاب تاس', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveBoardPainter extends CustomPainter {
  final List<int> points;
  final List<int> dice;
  final int? selectedPoint;
  final List<int> validMoves;

  InteractiveBoardPainter({
    required this.points,
    required this.dice,
    required this.selectedPoint,
    required this.validMoves,
  });

  @override
  void paint(Canvas canvas, Size size) {
    BoardRenderer.drawBoard(canvas, size);
    PieceRenderer.drawPieces(canvas, size, points);

    final margin = 16.0;
    final colW = (size.width - 2 * margin) / 12.0;

    // هایلایت ستون انتخاب شده با کادر طلایی
    if (selectedPoint != null) {
      final isTop = selectedPoint! >= 12;
      final col = isTop ? (selectedPoint! - 12) : (11 - selectedPoint!);
      final cx = margin + col * colW + colW / 2;
      final cy = isTop ? (margin + 35) : (size.height - margin - 35);

      final highlightPaint = Paint()
        ..color = Colors.amberAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(Offset(cx, cy), colW * 0.46, highlightPaint);
    }

    // رسم نشانگرهای سبز درخشان برای خانه‌های مقصد مجاز
    for (int target in validMoves) {
      final isTop = target >= 12;
      final col = isTop ? (target - 12) : (11 - target);
      final cx = margin + col * colW + colW / 2;
      final cy = isTop ? (margin + 60) : (size.height - margin - 60);

      // دایره سبز درخشان
      final glowPaint = Paint()..color = const Color(0xAA4CAF50);
      canvas.drawCircle(Offset(cx, cy), 16, glowPaint);

      final innerPaint = Paint()..color = const Color(0xFF81C784);
      canvas.drawCircle(Offset(cx, cy), 8, innerPaint);
    }

    // رسم تاس‌ها در مرکز
    if (dice.isNotEmpty) {
      final centerY = size.height / 2;
      final centerX = size.width / 2;
      DiceRenderer.drawDice(canvas, Offset(centerX - 35, centerY), dice[0]);
      if (dice.length > 1) {
        DiceRenderer.drawDice(canvas, Offset(centerX + 35, centerY), dice[1]);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
