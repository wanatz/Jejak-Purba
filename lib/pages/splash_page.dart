import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'main_shell_page.dart';
import 'onboarding_page.dart';

/// Layar pembuka dengan animasi logo. Setelah selesai, menuju onboarding
/// (pertama kali) atau langsung ke halaman utama.
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    );
    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );
    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final settings = context.read<SettingsProvider>();
    await Future.wait<void>([
      Future<void>.delayed(const Duration(milliseconds: 1700)),
      _waitForSettings(settings),
    ]);
    if (!mounted) return;
    final Widget target =
        settings.onboardingDone ? const MainShellPage() : const OnboardingPage();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> _waitForSettings(SettingsProvider settings) async {
    var guard = 0;
    while (!settings.isLoaded && guard < 40) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      guard++;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9A6B48), Color(0xFF4F2F1B)],
          ),
        ),
        child: CustomPaint(
          painter: const StrataPatternPainter(opacity: 0.10),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.white.op(0.14),
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(
                          color: Colors.white.op(0.35), width: 1.5),
                    ),
                    child: const Icon(Icons.landscape_rounded,
                        size: 60, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      Text(
                        AppInfo.name,
                        style: AppText.display(context,
                            size: 36, color: Colors.white, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppInfo.subtitle.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.op(0.8),
                          fontSize: 12,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
