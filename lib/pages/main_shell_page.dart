import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'explore_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';
import 'learn_page.dart';
import 'profile_page.dart';

/// Kerangka utama: 5 tab (Beranda, Jelajah, Belajar, Favorit, Profil) dengan
/// bilah navigasi bawah bergaya wireframe.
///
/// Memakai [IndexedStack] agar posisi scroll tiap tab tetap terjaga.
class MainShellPage extends StatefulWidget {
  const MainShellPage({Key? key}) : super(key: key);

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: <Widget>[
          HomePage(onOpenTab: _go),
          const ExplorePage(),
          const LearnPage(),
          const FavoritePage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(index: _index, onChanged: _go),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Bilah navigasi bawah: ikon + label, penanda aktif berupa pil lembut.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({Key? key, required this.index, required this.onChanged})
      : super(key: key);

  final int index;
  final ValueChanged<int> onChanged;

  static const List<_NavSpec> _items = [
    _NavSpec(Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    _NavSpec(Icons.explore_outlined, Icons.explore_rounded, 'Jelajah'),
    _NavSpec(Icons.school_outlined, Icons.school_rounded, 'Belajar'),
    _NavSpec(Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorit'),
    _NavSpec(Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.card,
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        width: active ? 54 : 38,
                        height: 32,
                        decoration: BoxDecoration(
                          color: active
                              ? p.primary.op(0.16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          size: 23,
                          color: active ? p.primary : p.muted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                          color: active ? p.primary : p.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
