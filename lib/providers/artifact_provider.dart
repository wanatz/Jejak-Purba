import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/artifact.dart';
import '../services/db_helper.dart';
import '../services/photo_service.dart';

/// Opsi pengurutan di halaman Jelajah.
enum ArtifactSort { newest, nameAsc, oldest, youngest }

extension ArtifactSortLabel on ArtifactSort {
  String get label {
    switch (this) {
      case ArtifactSort.newest:
        return 'Terbaru ditambahkan';
      case ArtifactSort.nameAsc:
        return 'Nama A - Z';
      case ArtifactSort.oldest:
        return 'Paling tua';
      case ArtifactSort.youngest:
        return 'Paling muda';
    }
  }
}

/// Satu fakta menarik beserta artefak asalnya (untuk kartu "Tahukah Kamu?").
class ArtifactFact {
  const ArtifactFact(this.artifact, this.text);
  final Artifact artifact;
  final String text;
}

/// Provider daftar artefak: data, pencarian, filter, pengurutan, catatan
/// pribadi, dan riwayat artefak yang pernah dilihat.
class ArtifactProvider extends ChangeNotifier {
  ArtifactProvider({DBHelper? db}) : _db = db ?? DBHelper.instance;

  static const List<String> materialGroups = [
    'Batu',
    'Tulang & Fosil',
    'Tanah Liat',
    'Logam',
    'Lainnya',
  ];

  final DBHelper _db;

  final List<Artifact> _artifacts = [];
  final Map<int, String> _notes = {};
  final List<int> _viewed = [];
  final Map<int, List<String>> _photos = {};

  String? _selectedEra;
  String? _selectedMaterial;
  String? _selectedMuseum;
  bool _favoritesOnly = false;
  String _searchQuery = '';
  ArtifactSort _sort = ArtifactSort.newest;
  bool _gridView = true;
  bool _loading = false;

  List<Artifact> get artifacts => List.unmodifiable(_artifacts);
  String? get selectedEra => _selectedEra;
  String? get selectedMaterial => _selectedMaterial;
  String? get selectedMuseum => _selectedMuseum;
  bool get favoritesOnly => _favoritesOnly;
  String get searchQuery => _searchQuery;
  ArtifactSort get sort => _sort;
  bool get gridView => _gridView;
  bool get isLoading => _loading;
  int get totalArtifacts => _artifacts.length;

  /// Jumlah filter lanjutan yang aktif (bahan, museum, favorit).
  int get advancedFilterCount =>
      (_selectedMaterial != null ? 1 : 0) +
      (_selectedMuseum != null ? 1 : 0) +
      (_favoritesOnly ? 1 : 0);

  /// Kelompok bahan untuk filter: Batu, Tulang & Fosil, Tanah Liat, Logam.
  static String materialGroup(Artifact a) {
    final m = a.material.toLowerCase();
    if (m.contains('perunggu') || m.contains('logam') || m.contains('besi')) {
      return 'Logam';
    }
    if (m.contains('tanah liat')) return 'Tanah Liat';
    if (m.contains('tulang') || m.contains('gading') || m.contains('fosil')) {
      return 'Tulang & Fosil';
    }
    if (m.contains('batu') || m.contains('kalsedon')) return 'Batu';
    return 'Lainnya';
  }

  /// Artefak yang lolos semua filter + pencarian, sudah terurut.
  List<Artifact> get filteredArtifacts {
    Iterable<Artifact> result = _artifacts;
    if (_selectedEra != null) {
      result = result.where((a) => a.era == _selectedEra);
    }
    if (_selectedMaterial != null) {
      result = result.where((a) => materialGroup(a) == _selectedMaterial);
    }
    if (_selectedMuseum != null) {
      result = result.where((a) => a.museum == _selectedMuseum);
    }
    if (_favoritesOnly) {
      result = result.where((a) => a.isFavorite);
    }
    if (_searchQuery.trim().isNotEmpty) {
      result = result.where((a) => matches(a, _searchQuery));
    }
    final list = result.toList();
    switch (_sort) {
      case ArtifactSort.newest:
        list.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case ArtifactSort.nameAsc:
        list.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case ArtifactSort.oldest:
        list.sort((a, b) => _ageKey(b, true).compareTo(_ageKey(a, true)));
        break;
      case ArtifactSort.youngest:
        list.sort((a, b) => _ageKey(a, false).compareTo(_ageKey(b, false)));
        break;
    }
    return list;
  }

  // Usia 0 (tidak diketahui) selalu di urutan paling akhir.
  int _ageKey(Artifact a, bool oldestFirst) {
    if (a.ageYears <= 0) return oldestFirst ? -1 : 1000000000000;
    return a.ageYears;
  }

  /// Apakah artefak cocok dengan kata kunci (nama, zaman, asal, bahan, dsb).
  static bool matches(Artifact a, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final haystack = [
      a.name,
      a.era,
      a.museum,
      a.origin,
      a.material,
      a.culture,
      a.description,
    ].join(' ').toLowerCase();
    return q.split(RegExp(r'\s+')).every(haystack.contains);
  }

  List<Artifact> search(String query, {String? era}) {
    return _artifacts
        .where((a) => (era == null || a.era == era) && matches(a, query))
        .toList(growable: false);
  }

  List<Artifact> get favoriteArtifacts =>
      _artifacts.where((a) => a.isFavorite).toList(growable: false);

  List<Artifact> get customArtifacts =>
      _artifacts.where((a) => a.isCustom).toList(growable: false);

  /// Artefak yang punya koordinat lokasi temuan (untuk peta).
  List<Artifact> get locatedArtifacts =>
      _artifacts.where((a) => a.hasLocation).toList(growable: false);

  int countByEra(String era) => _artifacts.where((a) => a.era == era).length;

  List<Artifact> byMuseum(String museumName) =>
      _artifacts.where((a) => a.museum == museumName).toList(growable: false);

  List<Artifact> byEra(String era) =>
      _artifacts.where((a) => a.era == era).toList(growable: false);

  /// Artefak pilihan beranda: bergantian per hari agar terasa segar.
  List<Artifact> featured({int count = 6}) {
    if (_artifacts.isEmpty) return const [];
    final builtIn = _artifacts.where((a) => !a.isCustom).toList();
    final pool = builtIn.isEmpty ? _artifacts : builtIn;
    final day = DateTime.now().difference(DateTime(2024)).inDays;
    final start = day % pool.length;
    final out = <Artifact>[];
    for (var i = 0; i < min(count, pool.length); i++) {
      out.add(pool[(start + i) % pool.length]);
    }
    return out;
  }

  /// Artefak lain di zaman yang sama (untuk "Artefak Terkait").
  List<Artifact> related(Artifact a, {int limit = 6}) {
    final same = _artifacts.where((x) => x.id != a.id && x.era == a.era);
    final others = _artifacts.where((x) => x.id != a.id && x.era != a.era);
    return [...same, ...others].take(limit).toList(growable: false);
  }

  /// Seluruh fakta menarik dari semua artefak.
  List<ArtifactFact> get facts {
    final out = <ArtifactFact>[];
    for (final a in _artifacts) {
      for (final f in a.funFactList) {
        out.add(ArtifactFact(a, f));
      }
    }
    return out;
  }

  Artifact? findById(int? id) {
    if (id == null) return null;
    for (final a in _artifacts) {
      if (a.id == id) return a;
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // Catatan pribadi
  // -------------------------------------------------------------------------
  String noteFor(int? id) => id == null ? '' : (_notes[id] ?? '');
  int get notesCount => _notes.length;

  /// Artefak yang punya catatan.
  List<Artifact> get annotatedArtifacts => _artifacts
      .where((a) => a.id != null && _notes.containsKey(a.id))
      .toList(growable: false);

  Future<void> setNote(int id, String text) async {
    final t = text.trim();
    if (t.isEmpty) {
      _notes.remove(id);
    } else {
      _notes[id] = t;
    }
    notifyListeners();
    await _db.saveNote(id, t);
  }

  // -------------------------------------------------------------------------
  // Riwayat dilihat
  // -------------------------------------------------------------------------
  int get viewedCount => _viewed.length;

  /// Artefak yang pernah dibuka, terbaru lebih dulu.
  List<Artifact> viewedArtifacts({int limit = 10}) {
    final out = <Artifact>[];
    for (final id in _viewed) {
      final a = findById(id);
      if (a != null) out.add(a);
      if (out.length >= limit) break;
    }
    return out;
  }

  /// Jumlah zaman berbeda dari artefak yang pernah dibuka.
  int get viewedEraCount {
    final eras = <String>{};
    for (final id in _viewed) {
      final a = findById(id);
      if (a != null) eras.add(a.era);
    }
    return eras.length;
  }

  Future<void> markViewed(int id) async {
    if (_viewed.isNotEmpty && _viewed.first == id) return;
    _viewed
      ..remove(id)
      ..insert(0, id);
    if (_viewed.length > 40) _viewed.removeRange(40, _viewed.length);
    notifyListeners();
    await _db.setSetting(DBHelper.keyViewed, _viewed.join(','));
  }

  // -------------------------------------------------------------------------
  // Data
  // -------------------------------------------------------------------------
  Future<void> loadArtifacts() async {
    _loading = true;
    notifyListeners();
    try {
      _photos
        ..clear()
        ..addAll(await _db.getAllPhotos());
      final rows = await _db.getAllArtifacts();
      _artifacts
        ..clear()
        ..addAll(rows.map((a) => a.copyWith(photos: _photos[a.id] ?? const [])));
      _notes
        ..clear()
        ..addAll(await _db.getAllNotes());
      final raw = await _db.getSetting(DBHelper.keyViewed);
      _viewed
        ..clear()
        ..addAll(raw
            .split(',')
            .map((e) => int.tryParse(e))
            .whereType<int>());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setEra(String? era) {
    if (_selectedEra == era) return;
    _selectedEra = era;
    notifyListeners();
  }

  void setMaterial(String? value) {
    if (_selectedMaterial == value) return;
    _selectedMaterial = value;
    notifyListeners();
  }

  void setMuseum(String? value) {
    if (_selectedMuseum == value) return;
    _selectedMuseum = value;
    notifyListeners();
  }

  void setFavoritesOnly(bool value) {
    if (_favoritesOnly == value) return;
    _favoritesOnly = value;
    notifyListeners();
  }

  void clearAdvancedFilters() {
    _selectedMaterial = null;
    _selectedMuseum = null;
    _favoritesOnly = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSort(ArtifactSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    notifyListeners();
  }

  void setGridView(bool value) {
    if (_gridView == value) return;
    _gridView = value;
    notifyListeners();
  }

  void clearFilters() {
    if (_selectedEra == null &&
        _searchQuery.isEmpty &&
        advancedFilterCount == 0) {
      return;
    }
    _selectedEra = null;
    _searchQuery = '';
    _selectedMaterial = null;
    _selectedMuseum = null;
    _favoritesOnly = false;
    notifyListeners();
  }

  Future<Artifact> addArtifact(Artifact artifact) async {
    final inserted = await _db.insertArtifact(artifact.copyWith(isCustom: true));
    final saved = inserted.copyWith(photos: artifact.photos);
    if (saved.id != null && artifact.photos.isNotEmpty) {
      _photos[saved.id!] = List<String>.from(artifact.photos);
      await _db.savePhotos(saved.id!, artifact.photos);
    }
    _artifacts.add(saved);
    notifyListeners();
    return saved;
  }

  Future<void> deleteArtifact(int id) async {
    for (final path in _photos[id] ?? const <String>[]) {
      await PhotoService.delete(path);
    }
    _photos.remove(id);
    await _db.savePhotos(id, const []);
    await _db.deleteArtifact(id);
    _artifacts.removeWhere((a) => a.id == id);
    _notes.remove(id);
    _viewed.remove(id);
    notifyListeners();
  }

  /// Menambahkan foto milik pengguna ke sebuah artefak.
  Future<void> addPhoto(Artifact artifact, String path) async {
    final id = artifact.id;
    if (id == null) return;
    final list = List<String>.from(_photos[id] ?? const <String>[])..add(path);
    _photos[id] = list;
    await _db.savePhotos(id, list);
    _replacePhotos(id, list);
  }

  /// Menghapus satu foto milik pengguna.
  Future<void> removePhoto(Artifact artifact, String path) async {
    final id = artifact.id;
    if (id == null) return;
    final list = List<String>.from(_photos[id] ?? const <String>[])
      ..remove(path);
    if (list.isEmpty) {
      _photos.remove(id);
    } else {
      _photos[id] = list;
    }
    await PhotoService.delete(path);
    await _db.savePhotos(id, list);
    _replacePhotos(id, list);
  }

  void _replacePhotos(int id, List<String> list) {
    final idx = _artifacts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _artifacts[idx] = _artifacts[idx].copyWith(photos: list);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Artifact artifact) async {
    if (artifact.id == null) return;
    final next = !artifact.isFavorite;
    HapticFeedback.lightImpact();
    await _db.setFavorite(artifact.id!, next);
    final idx = _artifacts.indexWhere((a) => a.id == artifact.id);
    if (idx != -1) {
      _artifacts[idx] = artifact.copyWith(isFavorite: next);
      notifyListeners();
    }
  }

  /// Menghapus koleksi buatan, favorit, catatan, dan riwayat.
  Future<void> resetUserData() async {
    for (final list in _photos.values) {
      for (final path in list) {
        await PhotoService.delete(path);
      }
    }
    _photos.clear();
    await _db.resetUserData();
    await loadArtifacts();
  }
}
