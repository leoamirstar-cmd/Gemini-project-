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
  List<int> currentDice = [1, 1];
  bool canRoll = true;
  String infoText = "برای شروع، تاس بریزید";

  void _rollDice() {
    if (!canRoll) return;

    setState(() {
      currentDice = DiceRenderer.roll();
      state.availableMoves = List.from(currentDice);
      canRoll = false;
      final turn = state.isWhiteTurn ? "سفید" : "سیاه";
      infoText = "نوبت: $turn | تاس: ${currentDice.join(' - ')}";
    });
  }

  void _nextTurn() {
    setState(() {
      state.isWhiteTurn = !state.isWhiteTurn;
      state.availableMoves.clear();
      canRoll = true;
      final turn = state.isWhiteTurn ? "سفید" : "سیاه";
      infoText = "نوبت: $turn | لمس دکمه برای پرتاب تاس";
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
          // نوار راهنما و وضعیت
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF2E1C12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  infoText,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _nextTurn,
                  child: const Text('پایان نوبت', style: TextStyle(color: Colors.amberAccent)),
                ),
              ],
            ),
          ),

          // میز بازی و تخته اصلی
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boardSize = Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  children: [
                    // رسم تخته و مهره‌ها و تاس
                    CustomPaint(
                      size: boardSize,
                      painter: BoardPainter(
                        points: state.points,
                        dice: currentDice,
                      ),
                    ),

                    // دکمه وسط برای پرتاب تاس
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  final List<int> points;
  final List<int> dice;

  BoardPainter({required this.points, required this.dice});

  @override
  void paint(Canvas canvas, Size size) {
    // ۱. رسم تخته
    BoardRenderer.drawBoard(canvas, size);

    // ۲. رسم مهره‌ها
    PieceRenderer.drawPieces(canvas, size, points);

    // ۳. رسم تاس‌ها وسط تخته
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
