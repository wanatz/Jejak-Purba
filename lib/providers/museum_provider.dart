import 'package:flutter/foundation.dart';

import '../models/museum.dart';
import '../services/db_helper.dart';
import 'artifact_provider.dart';

/// Daftar museum, jumlah koleksi per museum, dan museum favorit.
class MuseumProvider extends ChangeNotifier {
  MuseumProvider({DBHelper? db}) : _db = db ?? DBHelper.instance;

  final DBHelper _db;

  final List<Museum> _museums = [];
  final Set<String> _favorites = <String>{};
  bool _loading = false;

  final Map<String, int> _artifactCounts = {};

  List<Museum> get museums => List.unmodifiable(_museums);
  bool get isLoading => _loading;
  int get totalMuseums => _museums.length;

  List<Museum> get favoriteMuseums => _museums
      .where((m) => _favorites.contains(m.name))
      .toList(growable: false);

  bool isFavorite(String name) => _favorites.contains(name);

  int artifactCount(String name) => _artifactCounts[name] ?? 0;

  /// Dipanggil ChangeNotifierProxyProvider tiap daftar artefak berubah.
  void update(ArtifactProvider artifactProvider) {
    final counts = <String, int>{};
    for (final a in artifactProvider.artifacts) {
      counts[a.museum] = (counts[a.museum] ?? 0) + 1;
    }
    _artifactCounts
      ..clear()
      ..addAll(counts);
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      final rows = await _db.getAllMuseums();
      _museums
        ..clear()
        ..addAll(rows);
      final raw = await _db.getSetting(DBHelper.keyFavMuseums);
      _favorites
        ..clear()
        ..addAll(raw.split('|').where((e) => e.trim().isNotEmpty));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String name) async {
    if (!_favorites.remove(name)) _favorites.add(name);
    notifyListeners();
    await _db.setSetting(DBHelper.keyFavMuseums, _favorites.join('|'));
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    notifyListeners();
    await _db.setSetting(DBHelper.keyFavMuseums, '');
  }

  Museum? findByName(String name) {
    for (final m in _museums) {
      if (m.name == name) return m;
    }
    return null;
  }
}
