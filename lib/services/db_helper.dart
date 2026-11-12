import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/artifact.dart';
import '../models/museum.dart';
import 'seed_data.dart';

/// Helper basis data SQLite (singleton): tabel `artifacts`, `museums`,
/// dan `settings`. Data tersimpan di folder database aplikasi sehingga
/// favorit, koleksi tambahan, dan preferensi tetap ada setelah aplikasi
/// ditutup.
class DBHelper {
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();

  static const String _dbName = 'jatim_prehistoric.db';

  /// v2: tabel museums & settings.
  /// v3: detail artefak lebih kaya, sorotan museum, tanpa tiket/kunjungan.
  /// v4: koordinat lokasi temuan artefak.
  /// v5: ringkasan & arti penting artefak; foto milik pengguna.
  static const int _dbVersion = 5;

  static const String tableArtifacts = 'artifacts';
  static const String tableMuseums = 'museums';
  static const String tableSettings = 'settings';

  // Kunci preferensi di tabel `settings`.
  static const String keyThemeMode = 'theme_mode';
  static const String keyTextScale = 'text_scale';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyFavMuseums = 'fav_museums';
  static const String keyQuizBest = 'quiz_best';
  static const String keyQuizPlays = 'quiz_plays';
  static const String keyGameBest = 'game_best';
  static const String keyViewed = 'viewed_ids';
  static const String keyFlags = 'flags';
  static const String notePrefix = 'note_';
  static const String photoPrefix = 'photos_';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createArtifactsTable(db);
    await _createMuseumsTable(db);
    await _createSettingsTable(db);
    await _syncSeed(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMuseumsTable(db);
      await _createSettingsTable(db);
    }
    if (oldVersion < 3) {
      const artifactColumns = <String>[
        "dimensions TEXT NOT NULL DEFAULT ''",
        "culture TEXT NOT NULL DEFAULT ''",
        "discovery_year TEXT NOT NULL DEFAULT ''",
        "characteristics TEXT NOT NULL DEFAULT ''",
        "fun_facts TEXT NOT NULL DEFAULT ''",
        'age_years INTEGER NOT NULL DEFAULT 0',
      ];
      for (final col in artifactColumns) {
        await _tryExecute(db, 'ALTER TABLE $tableArtifacts ADD COLUMN $col');
      }
      await _tryExecute(db,
          "ALTER TABLE $tableMuseums ADD COLUMN highlights TEXT NOT NULL DEFAULT ''");
      await _renameLegacyArtifacts(db);
    }
    if (oldVersion < 5) {
      await _tryExecute(db,
          "ALTER TABLE $tableArtifacts ADD COLUMN summary TEXT NOT NULL DEFAULT ''");
      await _tryExecute(db,
          "ALTER TABLE $tableArtifacts ADD COLUMN significance TEXT NOT NULL DEFAULT ''");
    }
    if (oldVersion < 4) {
      await _tryExecute(
          db, 'ALTER TABLE $tableArtifacts ADD COLUMN find_lat REAL NOT NULL DEFAULT 0');
      await _tryExecute(
          db, 'ALTER TABLE $tableArtifacts ADD COLUMN find_lng REAL NOT NULL DEFAULT 0');
    }
    await _syncSeed(db);
  }

  Future<void> _tryExecute(Database db, String sql) async {
    try {
      await db.execute(sql);
    } catch (_) {
      // Kolom sudah ada: aman diabaikan.
    }
  }

  Future<void> _createArtifactsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableArtifacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        era TEXT NOT NULL,
        museum TEXT NOT NULL,
        origin TEXT NOT NULL,
        material TEXT NOT NULL,
        period TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        description TEXT NOT NULL,
        function_past TEXT NOT NULL,
        function_today TEXT NOT NULL DEFAULT '',
        discovery_info TEXT NOT NULL DEFAULT '',
        dimensions TEXT NOT NULL DEFAULT '',
        culture TEXT NOT NULL DEFAULT '',
        discovery_year TEXT NOT NULL DEFAULT '',
        characteristics TEXT NOT NULL DEFAULT '',
        fun_facts TEXT NOT NULL DEFAULT '',
        summary TEXT NOT NULL DEFAULT '',
        significance TEXT NOT NULL DEFAULT '',
        age_years INTEGER NOT NULL DEFAULT 0,
        find_lat REAL NOT NULL DEFAULT 0,
        find_lng REAL NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_custom INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createMuseumsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableMuseums (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        address TEXT NOT NULL,
        open_hours TEXT NOT NULL,
        ticket_price TEXT NOT NULL DEFAULT '',
        description TEXT NOT NULL,
        image TEXT NOT NULL,
        established TEXT NOT NULL,
        phone TEXT NOT NULL DEFAULT '',
        latitude REAL NOT NULL DEFAULT 0,
        longitude REAL NOT NULL DEFAULT 0,
        highlights TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<void> _createSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableSettings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // Seed & sinkronisasi data bawaan
  // ---------------------------------------------------------------------------

  /// Nama artefak versi lama -> nama baru, supaya status favorit tetap ada.
  static const Map<String, String> _legacyNames = {
    'Alat Tulang (Bone Tool)': 'Alat Tulang Sampung',
    'Sarkofagus Batu Nganjuk': 'Sarkofagus Batu',
    'Arca Batu Megalitik Nganjuk': 'Arca Batu Megalitik',
    'Kapak Corong Perunggu Mojokerto': 'Kapak Corong Perunggu',
  };

  Future<void> _renameLegacyArtifacts(Database db) async {
    for (final entry in _legacyNames.entries) {
      await db.update(
        tableArtifacts,
        {'name': entry.value},
        where: 'name = ? AND is_custom = 0',
        whereArgs: [entry.key],
      );
    }
  }

  /// Memasukkan data bawaan; bila sudah ada (nama sama) hanya memperbarui
  /// kontennya sehingga favorit & koleksi buatan pengguna tidak berubah.
  Future<void> _syncSeed(Database db) async {
    final batch = db.batch();

    for (final a in SeedData.artifacts) {
      final existing = await db.query(
        tableArtifacts,
        columns: ['id'],
        where: 'name = ? AND is_custom = 0',
        whereArgs: [a.name],
        limit: 1,
      );
      final map = a.toMap()..remove('id');
      if (existing.isEmpty) {
        batch.insert(tableArtifacts, map);
      } else {
        map
          ..remove('is_favorite')
          ..remove('is_custom');
        batch.update(
          tableArtifacts,
          map,
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      }
    }

    for (final m in SeedData.museums) {
      final existing = await db.query(
        tableMuseums,
        columns: ['id'],
        where: 'name = ?',
        whereArgs: [m.name],
        limit: 1,
      );
      final map = m.toMap()..remove('id');
      if (existing.isEmpty) {
        batch.insert(tableMuseums, map);
      } else {
        batch.update(
          tableMuseums,
          map,
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      }
    }

    await batch.commit(noResult: true);
  }

  // ---------------------------------------------------------------------------
  // CRUD: artifacts
  // ---------------------------------------------------------------------------
  Future<List<Artifact>> getAllArtifacts() async {
    final db = await database;
    final rows = await db.query(tableArtifacts, orderBy: 'id ASC');
    return rows.map(Artifact.fromMap).toList();
  }

  Future<Artifact> insertArtifact(Artifact artifact) async {
    final db = await database;
    final map = artifact.toMap()..remove('id');
    final id = await db.insert(tableArtifacts, map);
    return artifact.copyWith(id: id);
  }

  Future<int> setFavorite(int id, bool favorite) async {
    final db = await database;
    return db.update(
      tableArtifacts,
      {'is_favorite': favorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteArtifact(int id) async {
    final db = await database;
    return db.delete(tableArtifacts, where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // CRUD: museums
  // ---------------------------------------------------------------------------
  Future<List<Museum>> getAllMuseums() async {
    final db = await database;
    final rows = await db.query(tableMuseums, orderBy: 'id ASC');
    return rows.map(Museum.fromMap).toList();
  }

  // ---------------------------------------------------------------------------
  // settings (key-value)
  // ---------------------------------------------------------------------------
  Future<String> getSetting(String key, {String fallback = ''}) async {
    final db = await database;
    final rows = await db.query(
      tableSettings,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return fallback;
    return (rows.first['value'] ?? fallback) as String;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      tableSettings,
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Semua catatan pribadi: id artefak -> teks catatan.
  Future<Map<int, String>> getAllNotes() async {
    final db = await database;
    final rows = await db.query(
      tableSettings,
      where: 'key LIKE ?',
      whereArgs: ['$notePrefix%'],
    );
    final out = <int, String>{};
    for (final r in rows) {
      final id = int.tryParse((r['key'] as String).substring(notePrefix.length));
      final text = (r['value'] ?? '') as String;
      if (id != null && text.trim().isNotEmpty) out[id] = text;
    }
    return out;
  }

  Future<void> saveNote(int artifactId, String text) async {
    final db = await database;
    if (text.trim().isEmpty) {
      await db.delete(tableSettings,
          where: 'key = ?', whereArgs: ['$notePrefix$artifactId']);
    } else {
      await setSetting('$notePrefix$artifactId', text.trim());
    }
  }

  /// Foto milik pengguna: id artefak -> daftar path berkas.
  Future<Map<int, List<String>>> getAllPhotos() async {
    final db = await database;
    final rows = await db.query(
      tableSettings,
      where: 'key LIKE ?',
      whereArgs: ['$photoPrefix%'],
    );
    final out = <int, List<String>>{};
    for (final r in rows) {
      final id = int.tryParse((r['key'] as String).substring(photoPrefix.length));
      final list = ((r['value'] ?? '') as String)
          .split('|')
          .where((e) => e.trim().isNotEmpty)
          .toList();
      if (id != null && list.isNotEmpty) out[id] = list;
    }
    return out;
  }

  Future<void> savePhotos(int artifactId, List<String> paths) async {
    final db = await database;
    if (paths.isEmpty) {
      await db.delete(tableSettings,
          where: 'key = ?', whereArgs: ['$photoPrefix$artifactId']);
    } else {
      await setSetting('$photoPrefix$artifactId', paths.join('|'));
    }
  }

  /// Menghapus koleksi buatan pengguna dan mereset semua favorit.
  Future<void> resetUserData() async {
    final db = await database;
    await db.delete(tableArtifacts, where: 'is_custom = ?', whereArgs: [1]);
    await db.update(tableArtifacts, {'is_favorite': 0});
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyFavMuseums]);
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyQuizBest]);
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyQuizPlays]);
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyGameBest]);
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyViewed]);
    await db.delete(tableSettings, where: 'key = ?', whereArgs: [keyFlags]);
    await db.delete(tableSettings,
        where: 'key LIKE ?', whereArgs: ['$notePrefix%']);
    await db.delete(tableSettings,
        where: 'key LIKE ?', whereArgs: ['$photoPrefix%']);
  }
}
