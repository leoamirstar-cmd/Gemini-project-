class GameState {
  // ۲۴ خانه استاندارد تخته نرد
  // اعداد مثبت = مهره‌های سفید (حرکت در جهت کاهش شماره: از ۲۳ به سمت ۰)
  // اعداد منفی = مهره‌های سیاه (حرکت در جهت افزایش شماره: از ۰ به سمت ۲۳)
  List<int> points = [
    2, 0, 0, 0, 0, -5,   0, -3, 0, 0, 0, 5,
    -5, 0, 0, 0, 3, 0,   5, 0, 0, 0, 0, -2
  ];

  int whiteBar = 0; // مهره‌های سفید خورده شده
  int blackBar = 0; // مهره‌های سیاه خورده شده
  int whiteOff = 0; // مهره‌های سفید خارج شده
  int blackOff = 0; // مهره‌های سیاه خارج شده

  bool isWhiteTurn = true;
  List<int> dice = [];
  int? selectedPoint; // خانه‌ای که کاربر لمس کرده
  List<int> validMoves = []; // مقصدهای مجاز برای حرکت

  // محاسبه مقصدهای ممکن برای ستون انتخاب‌شده
  void selectPoint(int pointIndex) {
    if (dice.isEmpty) return;

    final count = points[pointIndex];
    // بررسی اینکه آیا مهره متعلق به بازیکن فعلی است یا نه
    if (isWhiteTurn && count <= 0) return;
    if (!isWhiteTurn && count >= 0) return;

    selectedPoint = pointIndex;
    validMoves.clear();

    final uniqueDice = dice.toSet().toList();
    for (int d in uniqueDice) {
      final target = isWhiteTurn ? (pointIndex - d) : (pointIndex + d);
      if (target >= 0 && target < 24) {
        if (_canMoveTo(target, isWhiteTurn)) {
          validMoves.add(target);
        }
      }
    }
  }

  // آیا می‌توان به خانه مقصد رفت؟
  bool _canMoveTo(int target, bool isWhite) {
    final count = points[target];
    if (isWhite) {
      // سفید می‌تواند برود اگر خالی باشد، مهره خودی باشد، یا حداکثر ۱ مهره سیاه باشد (برای زدن)
      return count >= -1;
    } else {
      // سیاه می‌تواند برود اگر خالی باشد، مهره خودی باشد، یا حداکثر ۱ مهره سفید باشد
      return count <= 1;
    }
  }

  // اجرای حرکت مهره
  bool makeMove(int from, int to) {
    final distance = (to - from).abs();
    if (!dice.contains(distance)) return false;

    // ۱. برداشتن مهره از مبدا
    if (isWhiteTurn) {
      points[from]--;
    } else {
      points[from]++;
    }

    // ۲. بررسی زدن مهره حریف
    if (isWhiteTurn) {
      if (points[to] == -1) {
        points[to] = 0;
        blackBar++; // مهره سیاه رفت روی پیشخوان!
      }
      points[to]++;
    } else {
      if (points[to] == 1) {
        points[to] = 0;
        whiteBar++; // مهره سفید رفت روی پیشخوان!
      }
      points[to]--;
    }

    // ۳. کسر تاس استفاده شده
    dice.remove(distance);
    selectedPoint = null;
    validMoves.clear();

    return true;
  }
}
