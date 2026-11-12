import 'package:flutter/material.dart';

import '../services/db_helper.dart';

/// Preferensi aplikasi yang bertahan lintas sesi: tema, onboarding, dan
/// rekor kuis. Disimpan di tabel `settings` SQLite.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider({DBHelper? db}) : _db = db ?? DBHelper.instance;

  final DBHelper _db;

  ThemeMode _themeMode = ThemeMode.system;
  bool _onboardingDone = false;
  bool _loaded = false;
  int _quizBest = 0;
  int _quizPlays = 0;
  int _gameBest = 0;
  double _textScale = 1.0;
  final Set<String> _flags = <String>{};

  ThemeMode get themeMode => _themeMode;
  bool get onboardingDone => _onboardingDone;
  bool get isLoaded => _loaded;

  /// Skor kuis terbaik dalam persen (0 - 100).
  int get quizBest => _quizBest;
  int get quizPlays => _quizPlays;

  /// Skor terbaik permainan Tebak Benda (persen).
  int get gameBest => _gameBest;

  /// Faktor ukuran teks aplikasi (0.9 - 1.3).
  double get textScale => _textScale;

  String get textScaleLabel {
    if (_textScale < 0.95) return 'Kecil';
    if (_textScale < 1.05) return 'Normal';
    if (_textScale < 1.2) return 'Besar';
    return 'Sangat besar';
  }

  bool hasFlag(String flag) => _flags.contains(flag);
  int get flagCount => _flags.length;

  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Ikuti sistem';
    }
  }

  Future<void> load() async {
    final themeValue =
        await _db.getSetting(DBHelper.keyThemeMode, fallback: 'system');
    final onboardingValue =
        await _db.getSetting(DBHelper.keyOnboardingDone, fallback: '0');
    final best = await _db.getSetting(DBHelper.keyQuizBest, fallback: '0');
    final plays = await _db.getSetting(DBHelper.keyQuizPlays, fallback: '0');
    final game = await _db.getSetting(DBHelper.keyGameBest, fallback: '0');
    final flags = await _db.getSetting(DBHelper.keyFlags);
    final scale = await _db.getSetting(DBHelper.keyTextScale, fallback: '1.0');

    _themeMode = _parseThemeMode(themeValue);
    _onboardingDone = onboardingValue == '1';
    _quizBest = int.tryParse(best) ?? 0;
    _quizPlays = int.tryParse(plays) ?? 0;
    _gameBest = int.tryParse(game) ?? 0;
    _textScale = (double.tryParse(scale) ?? 1.0).clamp(0.9, 1.3).toDouble();
    _flags
      ..clear()
      ..addAll(flags.split(',').where((e) => e.trim().isNotEmpty));
    _loaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _db.setSetting(DBHelper.keyThemeMode, _serializeThemeMode(mode));
  }

  Future<void> setTextScale(double value) async {
    final v = value.clamp(0.9, 1.3).toDouble();
    if (_textScale == v) return;
    _textScale = v;
    notifyListeners();
    await _db.setSetting(DBHelper.keyTextScale, '$v');
  }

  Future<void> completeOnboarding() async {
    if (_onboardingDone) return;
    _onboardingDone = true;
    notifyListeners();
    await _db.setSetting(DBHelper.keyOnboardingDone, '1');
  }

  Future<void> resetOnboarding() async {
    _onboardingDone = false;
    notifyListeners();
    await _db.setSetting(DBHelper.keyOnboardingDone, '0');
  }

  /// Mencatat hasil satu sesi kuis; rekor hanya naik.
  Future<void> recordQuiz(int percent) async {
    _quizPlays++;
    if (percent > _quizBest) _quizBest = percent;
    notifyListeners();
    await _db.setSetting(DBHelper.keyQuizBest, '$_quizBest');
    await _db.setSetting(DBHelper.keyQuizPlays, '$_quizPlays');
  }

  /// Mencatat skor Tebak Benda; rekor hanya naik.
  Future<void> recordGame(int percent) async {
    if (percent > _gameBest) {
      _gameBest = percent;
      notifyListeners();
      await _db.setSetting(DBHelper.keyGameBest, '$_gameBest');
    }
  }

  /// Menandai fitur yang pernah dibuka (untuk pencapaian).
  Future<void> markFlag(String flag) async {
    if (!_flags.add(flag)) return;
    notifyListeners();
    await _db.setSetting(DBHelper.keyFlags, _flags.join(','));
  }

  void clearQuizStats() {
    _quizBest = 0;
    _quizPlays = 0;
    _gameBest = 0;
    _flags.clear();
    notifyListeners();
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
