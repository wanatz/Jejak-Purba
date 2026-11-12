import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Tentang aplikasi: tujuan, cara memakai, catatan data, dan teknologi.
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [p.heroStart, p.heroEnd],
                    ),
                  ),
                  child: const Icon(Icons.landscape_rounded,
                      size: 52, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(AppInfo.name, style: AppText.display(context, size: 26)),
                const SizedBox(height: 4),
                Text('Versi ${AppInfo.version}',
                    style: AppText.muted(context, size: 13)),
                const SizedBox(height: 12),
                Text(
                  AppInfo.tagline,
                  textAlign: TextAlign.center,
                  style: AppText.body(context, size: 14.5, color: p.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('Tentang', style: AppText.display(context, size: 18)),
          const SizedBox(height: 8),
          Text(
            'Jejak Purba adalah katalog digital benda-benda prasejarah dari '
            'museum di Jawa Timur. Setiap artefak dilengkapi usia, bahan, '
            'budaya pembuat, ciri khas, fungsi dahulu dan kini, kisah '
            'penemuan, serta fakta menarik, sehingga cocok untuk belajar '
            'sebelum atau sesudah berkunjung ke museum.',
            style: AppText.body(context, size: 14.5, height: 1.65),
          ),
          const SizedBox(height: 24),
          Text('Cara Memakai', style: AppText.display(context, size: 18)),
          const SizedBox(height: 12),
          const _Step(
              n: 1,
              icon: Icons.explore_rounded,
              title: 'Jelajahi',
              text: 'Cari dan saring artefak berdasarkan zaman di tab Jelajah.'),
          const _Step(
              n: 2,
              icon: Icons.touch_app_rounded,
              title: 'Buka detail',
              text:
                  'Ketuk artefak, lalu buka bagian Ciri Khas, Fungsi, dan '
                  'Fakta Menarik.'),
          const _Step(
              n: 3,
              icon: Icons.favorite_rounded,
              title: 'Simpan favorit',
              text: 'Ketuk ikon hati untuk menyimpan artefak atau museum.'),
          const _Step(
              n: 4,
              icon: Icons.quiz_rounded,
              title: 'Uji dirimu',
              text: 'Mainkan kuis 10 soal dari menu Profil.'),
          const SizedBox(height: 22),
          SoftCard(
            color: p.soft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 19, color: p.primary),
                    const SizedBox(width: 8),
                    Text('Catatan tentang data',
                        style: AppText.display(context, size: 15.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Narasi disusun untuk tujuan edukasi dari literatur populer '
                  'arkeologi Indonesia. Gambar pada aplikasi adalah ilustrasi, '
                  'bukan foto koleksi asli. Untuk keperluan akademik, '
                  'rujuklah sumber resmi museum atau balai pelestarian cagar '
                  'budaya.',
                  style: AppText.body(context, size: 13.5, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Dibangun dengan', style: AppText.display(context, size: 18)),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag('Flutter'),
              _Tag('Provider'),
              _Tag('SQLite (sqflite)'),
              _Tag('Material 3'),
              _Tag('Offline-first'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.n,
    required this.icon,
    required this.title,
    required this.text,
  });

  final int n;
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: p.primary.op(0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: p.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$n. $title',
                    style: AppText.body(context,
                        size: 14.5, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(text, style: AppText.muted(context, size: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
    );
  }
}
