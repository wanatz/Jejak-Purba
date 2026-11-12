import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'main_shell_page.dart';

/// Pengantar 3 langkah yang hanya muncul pada pembukaan pertama.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _page = 0;

  static const List<_OnboardItem> _items = [
    _OnboardItem(
      image: 'assets/images/eras/palaeo.jpg',
      icon: Icons.account_balance_rounded,
      title: 'Koleksi Prasejarah Jatim',
      subtitle:
          'Kenali kapak batu, fosil manusia purba, gerabah, hingga nekara '
          'perunggu dari museum-museum di Jawa Timur.',
    ),
    _OnboardItem(
      image: 'assets/images/eras/neo.jpg',
      icon: Icons.timeline_rounded,
      title: 'Ikuti Alur Zaman',
      subtitle:
          'Dari Palaeolitikum sampai Zaman Logam: lihat bagaimana cara hidup '
          'dan teknologi manusia purba berubah dari masa ke masa.',
    ),
    _OnboardItem(
      image: 'assets/images/eras/logam.jpg',
      icon: Icons.favorite_rounded,
      title: 'Simpan & Uji Pengetahuan',
      subtitle:
          'Tandai artefak favorit, tambahkan koleksimu sendiri, dan tantang '
          'dirimu lewat kuis prasejarah.',
    ),
  ];

  void _next() {
    if (_page < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await context.read<SettingsProvider>().completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const MainShellPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final isLast = _page == _items.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLast ? 0 : 1,
                  child: TextButton(
                    onPressed: isLast ? null : _finish,
                    child: const Text('Lewati'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _OnboardSlide(item: _items[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_items.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? p.primary : p.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(isLast ? 'Mulai Menjelajah' : 'Lanjut'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem {
  const _OnboardItem({
    required this.image,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final IconData icon;
  final String title;
  final String subtitle;
}

class _OnboardSlide extends StatelessWidget {
  const _OnboardSlide({required this.item});

  final _OnboardItem item;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: p.heroEnd.op(0.30),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ArtImage(path: item.image),
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.op(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: p.heroEnd, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: AppText.display(context, size: 27),
          ),
          const SizedBox(height: 14),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: AppText.body(context,
                size: 15, color: p.muted, height: 1.55),
          ),
        ],
      ),
    );
  }
}
