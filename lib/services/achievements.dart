import 'package:flutter/material.dart';

import '../providers/artifact_provider.dart';
import '../providers/museum_provider.dart';
import '../providers/settings_provider.dart';

/// Satu pencapaian (lencana) beserta progresnya.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int progress;
  final int target;

  bool get unlocked => progress >= target;
  double get fraction => target == 0 ? 0 : (progress / target).clamp(0.0, 1.0);
}

/// Menghitung seluruh lencana dari keadaan aplikasi saat ini.
class Achievements {
  Achievements._();

  static List<Achievement> build({
    required ArtifactProvider artifacts,
    required MuseumProvider museums,
    required SettingsProvider settings,
  }) {
    int flag(String f) => settings.hasFlag(f) ? 1 : 0;
    return [
      Achievement(
        id: 'pemula',
        title: 'Penjelajah Pemula',
        description: 'Buka detail 5 artefak.',
        icon: Icons.explore_rounded,
        color: const Color(0xFF8A5A3B),
        progress: artifacts.viewedCount,
        target: 5,
      ),
      Achievement(
        id: 'keliling',
        title: 'Keliling Zaman',
        description: 'Lihat artefak dari kelima zaman.',
        icon: Icons.public_rounded,
        color: const Color(0xFF3F8A78),
        progress: artifacts.viewedEraCount,
        target: 5,
      ),
      Achievement(
        id: 'kolektor',
        title: 'Kolektor',
        description: 'Simpan 3 artefak favorit.',
        icon: Icons.favorite_rounded,
        color: const Color(0xFFD9534F),
        progress: artifacts.favoriteArtifacts.length,
        target: 3,
      ),
      Achievement(
        id: 'sahabat',
        title: 'Sahabat Museum',
        description: 'Simpan 1 museum favorit.',
        icon: Icons.account_balance_rounded,
        color: const Color(0xFFA4513A),
        progress: museums.favoriteMuseums.length,
        target: 1,
      ),
      Achievement(
        id: 'pencatat',
        title: 'Pencatat Rajin',
        description: 'Tulis catatan pribadi pada 1 artefak.',
        icon: Icons.edit_note_rounded,
        color: const Color(0xFFB8862F),
        progress: artifacts.notesCount,
        target: 1,
      ),
      Achievement(
        id: 'kurator',
        title: 'Kurator',
        description: 'Tambahkan 1 artefak ke Koleksi Saya.',
        icon: Icons.add_photo_alternate_rounded,
        color: const Color(0xFF6B8A45),
        progress: artifacts.customArtifacts.length,
        target: 1,
      ),
      Achievement(
        id: 'peneliti',
        title: 'Peneliti Muda',
        description: 'Capai skor kuis 70% atau lebih.',
        icon: Icons.school_rounded,
        color: const Color(0xFF3F8A78),
        progress: settings.quizBest,
        target: 70,
      ),
      Achievement(
        id: 'arkeolog',
        title: 'Arkeolog Handal',
        description: 'Raih skor kuis sempurna (100%).',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFFB8862F),
        progress: settings.quizBest,
        target: 100,
      ),
      Achievement(
        id: 'mata_elang',
        title: 'Mata Elang',
        description: 'Capai 80% di permainan Tebak Benda.',
        icon: Icons.visibility_rounded,
        color: const Color(0xFF8A5A3B),
        progress: settings.gameBest,
        target: 80,
      ),
      Achievement(
        id: 'penjaga_waktu',
        title: 'Penjaga Waktu',
        description: 'Buka halaman Linimasa Zaman.',
        icon: Icons.timeline_rounded,
        color: const Color(0xFF6B8A45),
        progress: flag('timeline'),
        target: 1,
      ),
      Achievement(
        id: 'kartografer',
        title: 'Kartografer',
        description: 'Buka Peta Situs Jawa Timur.',
        icon: Icons.map_rounded,
        color: const Color(0xFF3F8A78),
        progress: flag('map'),
        target: 1,
      ),
      Achievement(
        id: 'ahli_istilah',
        title: 'Ahli Istilah',
        description: 'Buka Glosarium prasejarah.',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFA4513A),
        progress: flag('glossary'),
        target: 1,
      ),
      Achievement(
        id: 'pembanding',
        title: 'Si Pembanding',
        description: 'Bandingkan dua artefak.',
        icon: Icons.compare_rounded,
        color: const Color(0xFFB8862F),
        progress: flag('compare'),
        target: 1,
      ),
      Achievement(
        id: 'kutu_buku',
        title: 'Kutu Buku',
        description: 'Belajar dengan Kartu Belajar.',
        icon: Icons.style_rounded,
        color: const Color(0xFF8A5A3B),
        progress: flag('cards'),
        target: 1,
      ),
    ];
  }
}
