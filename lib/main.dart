import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'کلوب تخته نرد',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainMenuScreen(),
    );
  }
}
