import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Kuis prasejarah 10 soal acak dengan penjelasan di setiap jawaban dan
/// halaman hasil yang menampilkan tinjauan jawaban salah.
class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Mulai sesi baru setelah frame pertama agar tidak memanggil
    // notifyListeners saat proses build.
    Future<void>.microtask(() {
      if (!mounted) return;
      context.read<QuizProvider>().start();
      setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final quiz = context.watch<QuizProvider>();
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: quiz.isFinished
              ? _ResultView(key: const ValueKey<String>('result'))
              : _QuestionView(key: ValueKey<int>(quiz.index)),
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final quiz = context.watch<QuizProvider>();
    final q = quiz.current!;
    final isLast = quiz.index == quiz.total - 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Keluar',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
              Expanded(
                child: Text('Soal ${quiz.index + 1} dari ${quiz.total}',
                    style: AppText.display(context, size: 17)),
              ),
              const HelpButton(
                title: 'Cara bermain Kuis',
                steps: [
                  'Ada 10 soal acak. Pilih satu jawaban untuk tiap soal.',
                  'Setelah menjawab, penjelasan muncul agar kamu belajar '
                      'dari jawabannya.',
                  'Skor 70% ke atas dianggap lulus. Rekor terbaik tersimpan '
                      'di Profil.',
                  'Di halaman hasil, jawaban yang salah bisa ditinjau ulang.',
                ],
              ),
              if (quiz.streak >= 2)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8862F).op(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded,
                          size: 15, color: Color(0xFFB8862F)),
                      const SizedBox(width: 3),
                      Text('${quiz.streak} beruntun',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB8862F))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                  begin: 0,
                  end: (quiz.index + (quiz.answered ? 1 : 0)) / quiz.total),
              duration: const Duration(milliseconds: 350),
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                backgroundColor: p.soft,
                valueColor: AlwaysStoppedAnimation<Color>(p.primary),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              if (q.era.isNotEmpty)
                Align(
                    alignment: Alignment.centerLeft,
                    child: EraBadge(era: q.era)),
              const SizedBox(height: 12),
              Text(q.question,
                  style: AppText.display(context, size: 21, height: 1.3)),
              const SizedBox(height: 20),
              for (var i = 0; i < q.options.length; i++)
                _OptionTile(
                  index: i,
                  text: q.options[i],
                  state: _stateFor(quiz, i),
                  onTap: quiz.answered ? null : () => quiz.answer(i),
                ),
              if (quiz.answered) ...[
                const SizedBox(height: 6),
                _Explanation(
                  correct: quiz.selectedIndex == q.correctIndex,
                  text: q.explanation,
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: quiz.answered
                  ? () {
                      quiz.next();
                      if (quiz.isFinished) {
                        context
                            .read<SettingsProvider>()
                            .recordQuiz(quiz.scorePercent);
                      }
                    }
                  : null,
              child: Text(isLast ? 'Lihat Hasil' : 'Soal Berikutnya'),
            ),
          ),
        ),
      ],
    );
  }

  _OptionState _stateFor(QuizProvider quiz, int i) {
    if (!quiz.answered) return _OptionState.idle;
    final correct = quiz.current!.correctIndex;
    if (i == correct) return _OptionState.correct;
    if (i == quiz.selectedIndex) return _OptionState.wrong;
    return _OptionState.dim;
  }
}

enum _OptionState { idle, correct, wrong, dim }

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final int index;
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    const green = Color(0xFF3F8A5C);
    const red = Color(0xFFD9534F);

    Color border = p.border;
    Color bg = p.card;
    Color badge = p.soft;
    Color badgeText = p.muted;
    IconData? trailing;

    switch (state) {
      case _OptionState.correct:
        border = green;
        bg = green.op(0.12);
        badge = green;
        badgeText = Colors.white;
        trailing = Icons.check_circle_rounded;
        break;
      case _OptionState.wrong:
        border = red;
        bg = red.op(0.10);
        badge = red;
        badgeText = Colors.white;
        trailing = Icons.cancel_rounded;
        break;
      case _OptionState.dim:
        bg = p.card.op(0.6);
        break;
      case _OptionState.idle:
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: border, width: state == _OptionState.idle ? 1 : 1.6),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
                child: Text(String.fromCharCode(65 + index),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: badgeText)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text,
                    style: AppText.body(context,
                        size: 14.5,
                        weight: FontWeight.w600,
                        color: state == _OptionState.dim ? p.muted : p.text)),
              ),
              if (trailing != null)
                Icon(trailing,
                    color: state == _OptionState.correct ? green : red),
            ],
          ),
        ),
      ),
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.correct, required this.text});

  final bool correct;
  final String text;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF3F8A5C);
    const red = Color(0xFFD9534F);
    final color = correct ? green : red;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.op(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.op(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.celebration_rounded : Icons.school_rounded,
                  size: 18, color: color),
              const SizedBox(width: 6),
              Text(correct ? 'Benar!' : 'Belum tepat',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: color, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: AppText.body(context, size: 13.5, height: 1.55)),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final quiz = context.watch<QuizProvider>();
    final settings = context.watch<SettingsProvider>();
    final newRecord =
        settings.quizPlays <= 1 || quiz.scorePercent >= settings.quizBest;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        Center(
          child: SizedBox(
            width: 190,
            height: 190,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: quiz.scorePercent / 100),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => CustomPaint(
                painter: _RingPainter(
                  progress: v,
                  track: p.soft,
                  color: quiz.passed ? const Color(0xFF3F8A5C) : p.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(v * 100).round()}%',
                          style: AppText.display(context, size: 42)),
                      Text('${quiz.score}/${quiz.total} benar',
                          style: AppText.muted(context, size: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(quiz.resultTitle,
            textAlign: TextAlign.center,
            style: AppText.display(context, size: 25)),
        const SizedBox(height: 8),
        Text(quiz.resultMessage,
            textAlign: TextAlign.center,
            style: AppText.body(context, size: 14.5, color: p.muted)),
        if (newRecord && quiz.scorePercent > 0) ...[
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB8862F).op(0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events_rounded,
                      size: 16, color: Color(0xFFB8862F)),
                  SizedBox(width: 5),
                  Text('Rekor terbaikmu',
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB8862F))),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
                child: _MiniStat(
                    icon: Icons.check_circle_outline_rounded,
                    value: '${quiz.score}',
                    label: 'Benar')),
            const SizedBox(width: 10),
            Expanded(
                child: _MiniStat(
                    icon: Icons.highlight_off_rounded,
                    value: '${quiz.total - quiz.score}',
                    label: 'Salah')),
            const SizedBox(width: 10),
            Expanded(
                child: _MiniStat(
                    icon: Icons.local_fire_department_rounded,
                    value: '${quiz.bestStreak}',
                    label: 'Beruntun')),
          ],
        ),
        if (quiz.mistakes.isNotEmpty) ...[
          const SizedBox(height: 26),
          Text('Tinjau Jawaban Salah',
              style: AppText.display(context, size: 18)),
          const SizedBox(height: 12),
          for (final m in quiz.mistakes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.question.question,
                        style: AppText.body(context,
                            size: 13.5, weight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.close_rounded,
                            size: 16, color: Color(0xFFD9534F)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(m.question.options[m.chosenIndex],
                              style: AppText.body(context,
                                  size: 13, color: const Color(0xFFD9534F))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 16, color: Color(0xFF3F8A5C)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(m.question.correctAnswer,
                              style: AppText.body(context,
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF3F8A5C))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(m.question.explanation,
                        style: AppText.muted(context, size: 12.5)),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 22),
        ElevatedButton.icon(
          onPressed: () => quiz.start(),
          icon: const Icon(Icons.replay_rounded, size: 20),
          label: const Text('Main Lagi'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Selesai'),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      color: p.soft,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Icon(icon, color: p.primary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppText.display(context, size: 20)),
          Text(label, style: AppText.muted(context, size: 12)),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.color,
  });

  final double progress;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 15.0;
    final rect = Offset.zero & size;
    final deflated = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(deflated, 0, math.pi * 2, false, base);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(deflated, -math.pi / 2, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}
