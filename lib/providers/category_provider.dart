import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'artifact_provider.dart';

/// Definisi satu zaman prasejarah: dipakai di beranda, katalog, dan timeline.
class PrehistoricCategory {
  const PrehistoricCategory({
    required this.name,
    required this.range,
    required this.highlight,
    required this.description,
    required this.lifestyle,
    required this.tools,
    required this.humans,
    required this.sites,
  });

  final String name;

  /// Rentang waktu dalam teks.
  final String range;

  /// Kalimat pendek ciri utama zaman.
  final String highlight;
  final String description;
  final String lifestyle;
  final String tools;
  final String humans;
  final String sites;

  Color get color => EraStyle.color(name);
  IconData get icon => EraStyle.icon(name);
}

/// Daftar zaman prasejarah + jumlah artefak per zaman.
class CategoryProvider extends ChangeNotifier {
  CategoryProvider();

  static const List<PrehistoricCategory> allCategories = [
    PrehistoricCategory(
      name: 'Palaeolitikum',
      range: '± 2 juta - 11.700 tahun lalu',
      highlight: 'Batu dipangkas kasar, hidup berburu & meramu',
      description:
          'Zaman batu tua. Manusia purba hidup berpindah-pindah di sekitar '
          'sungai dan padang rumput, berburu, meramu, dan mulai mengenal '
          'api. Alatnya dibuat dengan memukul batu hingga tajam.',
      lifestyle: 'Nomaden, berkelompok kecil, mengenal api',
      tools: 'Kapak genggam, kapak perimbas, alat serpih',
      humans: 'Homo erectus (Manusia Jawa) dan Homo sapiens awal',
      sites: 'Trinil (Ngawi), Pacitan, Wajak (Tulungagung)',
    ),
    PrehistoricCategory(
      name: 'Mesolitikum',
      range: '± 11.700 - 5.000 tahun lalu',
      highlight: 'Mikrolit, alat tulang & hunian gua',
      description:
          'Zaman batu tengah. Iklim menghangat setelah Zaman Es. Manusia '
          'mulai menghuni gua, mengumpulkan kerang, dan berburu dengan '
          'busur. Alat batu mengecil menjadi mikrolit.',
      lifestyle: 'Semi-menetap di gua dan ceruk batu',
      tools: 'Mikrolit, alat tulang, pipisan',
      humans: 'Homo sapiens pemburu-peramu',
      sites: 'Gua Lawa Sampung (Ponorogo), gua karst Pacitan',
    ),
    PrehistoricCategory(
      name: 'Neolitikum',
      range: '± 4.500 - 2.500 tahun lalu',
      highlight: 'Bercocok tanam, gerabah & beliung halus',
      description:
          'Zaman batu muda. Manusia mulai bercocok tanam, beternak, dan '
          'menetap di desa. Alat batu diasah dan dipoles halus, serta '
          'gerabah dibuat untuk menyimpan hasil panen.',
      lifestyle: 'Menetap, bertani, beternak',
      tools: 'Beliung persegi, gerabah, gelang batu',
      humans: 'Penutur Austronesia',
      sites: 'Pacitan, Tulungagung, Nganjuk',
    ),
    PrehistoricCategory(
      name: 'Megalitikum',
      range: '± 3.500 - 1.500 tahun lalu',
      highlight: 'Menhir, dolmen, sarkofagus & arca',
      description:
          'Zaman batu besar. Masyarakat membangun monumen batu untuk '
          'memuja arwah leluhur, tanda kepercayaan dan gotong royong '
          'yang kuat. Sebagian tradisinya bertahan hingga kini.',
      lifestyle: 'Desa agraris, pemujaan leluhur',
      tools: 'Menhir, dolmen, sarkofagus, arca batu',
      humans: 'Masyarakat agraris Austronesia',
      sites: 'Bondowoso, Nganjuk',
    ),
    PrehistoricCategory(
      name: 'Zaman Logam',
      range: '± 2.500 - 1.500 tahun lalu',
      highlight: 'Perunggu, besi & perdagangan jarak jauh',
      description:
          'Zaman perunggu dan besi. Teknik melebur dan mencetak logam '
          'datang lewat jaringan dagang Asia Tenggara dan melahirkan '
          'perkakas, genderang, dan perhiasan bernilai tinggi.',
      lifestyle: 'Masyarakat berstrata, berdagang jauh',
      tools: 'Kapak corong, nekara, manik-manik',
      humans: 'Masyarakat agraris Austronesia',
      sites: 'Mojokerto, Pasuruan, situs kubur Jawa Timur',
    ),
  ];

  Map<String, int> _counts = const {};

  List<PrehistoricCategory> get categories => allCategories;
  int get totalCategories => allCategories.length;

  int countOf(String name) => _counts[name] ?? 0;

  PrehistoricCategory? categoryByName(String? name) {
    if (name == null) return null;
    for (final c in allCategories) {
      if (c.name == name) return c;
    }
    return null;
  }

  /// Dipanggil ChangeNotifierProxyProvider tiap data artefak berubah.
  void update(ArtifactProvider artifactProvider) {
    final next = <String, int>{
      for (final c in allCategories) c.name: artifactProvider.countByEra(c.name),
    };
    if (!_same(next, _counts)) {
      _counts = next;
      notifyListeners();
    }
  }

  bool _same(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (b[e.key] != e.value) return false;
    }
    return true;
  }
}
