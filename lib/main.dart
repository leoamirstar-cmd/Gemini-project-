import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'game/backgammon_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // قفل کردن بازی در حالت عمودی (پرتره) برای کنترل راحت با یک دست
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const BackgammonApp());
}

class BackgammonApp extends StatelessWidget {
  const BackgammonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تخته نرد پارسی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget(
          game: BackgammonFlameGame(),
        ),
      ),
    );
  }
}
