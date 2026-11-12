import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/quiz_question.dart';

/// Pencatat satu jawaban salah untuk ditinjau di halaman hasil.
class QuizMistake {
  const QuizMistake(this.question, this.chosenIndex);
  final QuizQuestion question;
  final int chosenIndex;
}

/// Mesin kuis: urutan soal, jawaban, skor, dan tinjauan jawaban salah.
class QuizProvider extends ChangeNotifier {
  QuizProvider() {
    start();
  }

  /// Jumlah soal per sesi.
  static const int sessionLength = 10;

  late List<QuizQuestion> _questions;
  final List<QuizMistake> _mistakes = [];
  int _index = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _streak = 0;
  int _bestStreak = 0;

  List<QuizQuestion> get questions => List.unmodifiable(_questions);
  List<QuizMistake> get mistakes => List.unmodifiable(_mistakes);
  int get index => _index;
  int get score => _score;
  int? get selectedIndex => _selectedIndex;
  bool get answered => _answered;
  bool get isFinished => _index >= _questions.length;
  int get total => _questions.length;
  int get streak => _streak;
  int get bestStreak => _bestStreak;

  QuizQuestion? get current => isFinished ? null : _questions[_index];

  double get progress =>
      _questions.isEmpty ? 0 : (_index / _questions.length).clamp(0.0, 1.0);

  int get scorePercent => total == 0 ? 0 : ((_score / total) * 100).round();
  bool get passed => scorePercent >= 70;

  String get resultMessage {
    if (scorePercent >= 90) return 'Luar biasa! Kamu hampir jadi arkeolog.';
    if (scorePercent >= 70) return 'Bagus! Pemahamanmu sudah solid.';
    if (scorePercent >= 50) return 'Cukup baik, baca lagi detail artefaknya.';
    return 'Jangan menyerah. Mulai dari Jelajah artefak ya!';
  }

  String get resultTitle {
    if (scorePercent >= 90) return 'Arkeolog Handal';
    if (scorePercent >= 70) return 'Penjelajah Andal';
    if (scorePercent >= 50) return 'Peneliti Muda';
    return 'Pemula Penasaran';
  }

  void start() {
    final all = List<QuizQuestion>.from(kQuizQuestions)..shuffle();
    _questions = all.take(sessionLength).toList();
    _mistakes.clear();
    _index = 0;
    _score = 0;
    _streak = 0;
    _bestStreak = 0;
    _selectedIndex = null;
    _answered = false;
    notifyListeners();
  }

  void answer(int optionIndex) {
    if (_answered || isFinished) return;
    _selectedIndex = optionIndex;
    _answered = true;
    HapticFeedback.selectionClick();
    final q = current!;
    if (optionIndex == q.correctIndex) {
      _score++;
      _streak++;
      if (_streak > _bestStreak) _bestStreak = _streak;
    } else {
      _streak = 0;
      _mistakes.add(QuizMistake(q, optionIndex));
    }
    notifyListeners();
  }

  void next() {
    if (!_answered) return;
    _index++;
    _selectedIndex = null;
    _answered = false;
    notifyListeners();
  }
}
