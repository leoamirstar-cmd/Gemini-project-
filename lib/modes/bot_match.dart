import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../components/board_component.dart';
import '../components/piece_component.dart';
import '../components/dice_component.dart';

class BotMatchScreen extends StatefulWidget {
  const BotMatchScreen({super.key});

  @override
  State<BotMatchScreen> createState() => _BotMatchScreenState();
}

class _BotMatchScreenState extends State<BotMatchScreen> {
  final GameState state = GameState();
  List<int> currentDice = [1, 1];
  bool isPlayerTurn = true; // بازیکن = سفید، ربات = سیاه
  bool canRoll = true;
  String infoText = "نوبت شماست (سفید) - تاس بریزید";

  void _playerRoll() {
    if (!canRoll || !isPlayerTurn) return;

    setState(() {
      currentDice = DiceRenderer.roll();
      canRoll = false;
      infoText = "تاس شما: ${currentDice.join(' و ')}";
    });
  }

  void _endPlayerTurn() {
    if (isPlayerTurn && !canRoll) {
      setState(() {
        isPlayerTurn = false;
        canRoll = false;
        infoText = "ربات در حال فکر کردن و پرتاب تاس...";
      });

      // تاخیر ۱.۵ ثانیه‌ای برای حس واقعی فکر کردن ربات
      Timer(const Duration(milliseconds: 1500), _botPlay);
    }
  }

  void _botPlay() {
    final botDice = DiceRenderer.roll();
    setState(() {
      currentDice = botDice;
      infoText = "تاس ربات (سیاه): ${botDice.join(' و ')}";
    });

    // تاخیر دوم برای انجام حرکت ربات و برگرداندن نوبت به کاربر
    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        isPlayerTurn = true;
        canRoll = true;
        infoText = "نوبت شماست (سفید) - تاس بریزید";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E140E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF24160E),
        elevation: 0,
        title: const Text('تخته نرد (رقابت با هوش مصنوعی)', style: TextStyle(color: Colors.amber, fontSize: 17)),
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
                Expanded(
                  child: Text(
                    infoText,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isPlayerTurn && !canRoll)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
                    onPressed: _endPlayerTurn,
                    child: const Text('پایان حرکت', style: TextStyle(color: Colors.black87, fontSize: 12)),
                  ),
              ],
            ),
          ),

          // تخته بازی
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boardSize = Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  children: [
                    CustomPaint(
                      size: boardSize,
                      painter: BoardPainter(
                        points: state.points,
                        dice: currentDice,
                      ),
                    ),

                    if (isPlayerTurn && canRoll)
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _playerRoll,
                          icon: const Icon(Icons.casino),
                          label: const Text('پرتاب تاس من', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    BoardRenderer.drawBoard(canvas, size);
    PieceRenderer.drawPieces(canvas, size, points);

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
