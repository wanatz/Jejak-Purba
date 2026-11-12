import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Pembaca suara (text-to-speech) berbahasa Indonesia untuk penjelasan
/// artefak. Memakai mesin suara bawaan perangkat, jadi tetap offline.
class NarrationService {
  NarrationService._();

  static final NarrationService instance = NarrationService._();

  final FlutterTts _tts = FlutterTts();

  /// true selama suara sedang dibacakan.
  final ValueNotifier<bool> speaking = ValueNotifier<bool>(false);

  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(0.46);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() => speaking.value = false);
      _tts.setCancelHandler(() => speaking.value = false);
      _tts.setErrorHandler((dynamic _) => speaking.value = false);
    } catch (_) {
      // Mesin suara tidak tersedia: abaikan, tombol tetap aman dipakai.
    }
  }

  /// Membacakan [text]. Mengembalikan false bila gagal.
  Future<bool> speak(String text) async {
    await _init();
    try {
      await _tts.stop();
      speaking.value = true;
      await _tts.speak(text);
      return true;
    } catch (_) {
      speaking.value = false;
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // abaikan
    }
    speaking.value = false;
  }
}
