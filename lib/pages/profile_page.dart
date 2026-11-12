import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../providers/museum_provider.dart';
import '../providers/settings_provider.dart';
import '../services/achievements.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'about_page.dart';
import 'achievements_page.dart';
import 'admin_page.dart';
import 'guide_page.dart';
import 'notes_page.dart';
import 'onboarding_page.dart';
import 'quiz_page.dart';
import 'timeline_page.dart';

/// Profil: ringkasan aktivitas + menu (linimasa, kuis, koleksi saya,
/// tampilan, tentang, reset).
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifacts = context.watch<ArtifactProvider>();
    final museums = context.watch<MuseumProvider>();
    final settings = context.watch<SettingsProvider>();

    final badges = Achievements.build(
        artifacts: artifacts, museums: museums, settings: settings);
    final unlocked = badges.where((b) => b.unlocked).length;
    final favCount =
        artifacts.favoriteArtifacts.length + museums.favoriteMuseums.length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            Text('Profil', style: AppText.display(context, size: 26)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [p.heroStart, p.heroEnd],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: CustomPaint(
                  painter: const StrataPatternPainter(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.white.op(0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.op(0.4),
                                  width: 1.5),
                            ),
                            child: const Icon(Icons.travel_explore_rounded,
                                color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Penjelajah Prasejarah',
                                    style: AppText.display(context,
                                        size: 19, color: Colors.white)),
                                const SizedBox(height: 3),
                                Text(
                                  'Pencinta sejarah & benda kuno',
                                  style: TextStyle(
                                      color: Colors.white.op(0.8),
                                      fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _HeroStat(value: '$favCount', label: 'Favorit'),
                          _HeroStat(value: '$unlocked', label: 'Lencana'),
                          _HeroStat(
                              value: settings.quizPlays == 0
                                  ? '-'
                                  : '${settings.quizBest}%',
                              label: 'Skor Kuis'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _GroupTitle('Aktivitas'),
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.emoji_events_rounded,
                  title: 'Pencapaian',
                  subtitle: '$unlocked dari ${badges.length} lencana terbuka',
                  onTap: () =>
                      AppRoute.push(context, const AchievementsPage()),
                ),
                _MenuItem(
                  icon: Icons.edit_note_rounded,
                  title: 'Catatan Saya',
                  subtitle: artifacts.notesCount == 0
                      ? 'Tulis catatan di detail artefak'
                      : '${artifacts.notesCount} catatan tersimpan',
                  onTap: () => AppRoute.push(context, const NotesPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _GroupTitle('Belajar & Bermain'),
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.timeline_rounded,
                  title: 'Linimasa Zaman',
                  subtitle: '5 zaman prasejarah, dari tertua hingga termuda',
                  onTap: () => AppRoute.push(context, const TimelinePage()),
                ),
                _MenuItem(
                  icon: Icons.quiz_rounded,
                  title: 'Kuis Prasejarah',
                  subtitle: settings.quizPlays == 0
                      ? 'Uji pengetahuanmu, 10 soal acak'
                      : 'Rekor terbaik ${settings.quizBest}% · '
                          '${settings.quizPlays}x main',
                  onTap: () => AppRoute.push(context, const QuizPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _GroupTitle('Koleksi'),
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.add_photo_alternate_rounded,
                  title: 'Koleksi Buatanku',
                  subtitle: artifacts.customArtifacts.isEmpty
                      ? 'Tambahkan artefak temuanmu sendiri'
                      : '${artifacts.customArtifacts.length} artefak '
                          'buatanmu',
                  onTap: () => AppRoute.push(context, const AdminPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _GroupTitle('Pengaturan'),
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.palette_outlined,
                  title: 'Tampilan',
                  subtitle: settings.themeModeLabel,
                  onTap: () => _showThemeSheet(context),
                ),
                _MenuItem(
                  icon: Icons.text_fields_rounded,
                  title: 'Ukuran Teks',
                  subtitle: settings.textScaleLabel,
                  onTap: () => _showTextSizeSheet(context),
                ),
                _MenuItem(
                  icon: Icons.slideshow_rounded,
                  title: 'Lihat Pengantar Lagi',
                  subtitle: 'Ulangi layar sambutan',
                  onTap: () {
                    context.read<SettingsProvider>().resetOnboarding();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                          builder: (_) => const OnboardingPage()),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Panduan Penggunaan',
                  subtitle: 'Cara memakai tiap fitur & pertanyaan umum',
                  onTap: () => AppRoute.push(context, const GuidePage()),
                ),
                _MenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'Versi ${AppInfo.version}',
                  onTap: () => AppRoute.push(context, const AboutPage()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.delete_sweep_outlined,
                  title: 'Hapus Data Saya',
                  subtitle: 'Favorit, koleksi buatan, dan rekor kuis',
                  danger: true,
                  onTap: () => _confirmReset(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSheet(BuildContext context) {
    final p = AppPalette.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        final settings = ctx.watch<SettingsProvider>();
        Widget option(ThemeMode mode, IconData icon, String label) {
          final selected = settings.themeMode == mode;
          return ListTile(
            leading: Icon(icon, color: selected ? p.primary : p.muted),
            title: Text(label,
                style: TextStyle(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
            trailing: selected
                ? Icon(Icons.check_circle_rounded, color: p.primary)
                : null,
            onTap: () {
              settings.setThemeMode(mode);
              Navigator.of(ctx).pop();
            },
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Tampilan', style: AppText.display(context, size: 19)),
                const SizedBox(height: 6),
                option(ThemeMode.system, Icons.brightness_auto_rounded,
                    'Ikuti sistem'),
                option(ThemeMode.light, Icons.light_mode_rounded, 'Terang'),
                option(ThemeMode.dark, Icons.dark_mode_rounded, 'Gelap'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTextSizeSheet(BuildContext context) {
    final p = AppPalette.of(context);
    const options = <List<Object>>[
      ['Kecil', 0.9],
      ['Normal', 1.0],
      ['Besar', 1.15],
      ['Sangat besar', 1.3],
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        final settings = ctx.watch<SettingsProvider>();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Ukuran Teks', style: AppText.display(ctx, size: 19)),
                const SizedBox(height: 4),
                Text('Contoh: Kapak genggam digenggam tanpa tangkai.',
                    style: AppText.muted(ctx)),
                const SizedBox(height: 6),
                for (final o in options)
                  ListTile(
                    leading: Icon(
                      (settings.textScale - (o[1] as double)).abs() < 0.01
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: p.primary,
                    ),
                    title: Text(o[0] as String),
                    onTap: () {
                      settings.setTextScale(o[1] as double);
                      Navigator.of(ctx).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final artifacts = context.read<ArtifactProvider>();
    final museums = context.read<MuseumProvider>();
    final settings = context.read<SettingsProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus data saya?'),
        content: const Text(
            'Semua favorit, koleksi buatanmu, dan rekor kuis akan dihapus. '
            'Koleksi bawaan aplikasi tidak terpengaruh.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;
    await artifacts.resetUserData();
    await museums.clearFavorites();
    settings.clearQuizStats();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: AppText.display(context, size: 22, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.op(0.8), fontSize: 12)),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text.toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppPalette.of(context).muted,
          )),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _row(context, items[i], p),
            if (i != items.length - 1)
              Divider(height: 1, indent: 66, color: p.border),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, _MenuItem item, AppPalette p) {
    final color = item.danger ? const Color(0xFFD9534F) : p.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.op(0.13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: color, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: item.danger ? color : p.text)),
                    const SizedBox(height: 2),
                    Text(item.subtitle,
                        style: AppText.muted(context, size: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: p.muted),
            ],
          ),
        ),
      ),
    );
  }
}
