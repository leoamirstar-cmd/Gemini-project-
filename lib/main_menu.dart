import 'package:flutter/material.dart';
import 'modes/pass_and_play.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A120B),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوگو و عنوان بازی
                const Icon(Icons.casino, size: 72, color: Colors.amber),
                const SizedBox(height: 16),
                const Text(
                  'کلوب تخته نرد پارسی',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مجموعه بازی‌های کلاسیک و دونفره',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                const SizedBox(height: 48),

                // دکمه ۱: بازی دو نفره آفلاین
                _MenuButton(
                  title: '🎲 بازی دو نفره (روی یک گوشی)',
                  subtitle: 'همراه با دوست یا خانواده بدون اینترنت',
                  isLocked: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PassAndPlayScreen()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // دکمه ۲: بازی با هوش مصنوعی (در مرحله بعد تکمیل می‌کنیم)
                _MenuButton(
                  title: '🤖 بازی با ربات هوشمند',
                  subtitle: 'تمرین آفلاین در ۳ سطح مبتدی تا حرفه‌ای',
                  isLocked: true,
                  badge: 'به‌زودی',
                  onTap: () {},
                ),

                const SizedBox(height: 16),

                // دکمه ۳: سایر بازی‌ها
                _MenuButton(
                  title: '❌⭕ دوز و مار و پله',
                  subtitle: 'بسته بازی‌های نوستالژیک دورهمی',
                  isLocked: true,
                  badge: 'آپدیت بعدی',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLocked;
  final String? badge;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.subtitle,
    required this.isLocked,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Material(
        color: const Color(0xFF2A1C12),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLocked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
