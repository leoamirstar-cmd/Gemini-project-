class GameState {
  // ۲۴ خانه استاندارد تخته نرد
  // اعداد مثبت = مهره‌های سفید | اعداد منفی = مهره‌های سیاه
  List<int> points = [
    2, 0, 0, 0, 0, -5,   0, -3, 0, 0, 0, 5,
    -5, 0, 0, 0, 3, 0,   5, 0, 0, 0, 0, -2
  ];

  // مهره‌های خورده شده روی پیشخوان (Bar)
  int whiteBar = 0;
  int blackBar = 0;

  // مهره‌های خارج شده از بازی (Borne off)
  int whiteOff = 0;
  int blackOff = 0;

  bool isWhiteTurn = true;
  List<int> availableMoves = []; // حرکات باقی‌مانده از تاس
}
