import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Permainan "Tebak Benda": lihat foto artefak (kadang hanya detail
/// permukaannya) lalu tebak namanya dari 4 pilihan.
class GuessGamePage extends StatefulWidget {
  const GuessGamePage({Key? key}) : super(key: key);

  @override
  State<GuessGamePage> createState() => _GuessGamePageState();
}

class _Round {
  _Round(this.answer, this.options, this.hard);
  final Artifact answer;
  final List<Artifact> options;
  final bool hard;
}

class _GuessGamePageState extends State<GuessGamePage> {
  static const int _rounds = 10;

  List<_Round> _deck = [];
  int _index = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int? _picked;
  bool _recorded = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) _start();
    });
  }

  void _start() {
    final all = context
        .read<ArtifactProvider>()
        .artifacts
        .where((a) => !a.isCustom)
        .toList();
    if (all.length < 4) {
      setState(() => _deck = []);
      return;
    }
    all.shuffle();
    final picks = all.take(_rounds).toList();
    final deck = <_Round>[];
    for (var i = 0; i < picks.length; i++) {
      final answer = picks[i];
      final others = all.where((a) => a.id != answer.id).toList()..shuffle();
      // Pilihan yang menyesatkan: utamakan zaman yang sama.
      others.sort((x, y) =>
          (y.era == answer.era ? 1 : 0).compareTo(x.era == answer.era ? 1 : 0));
      final opts = <Artifact>[answer, ...others.take(3)]..shuffle();
      deck.add(_Round(answer, opts, i % 3 == 2));
    }
    setState(() {
      _deck = deck;
      _index = 0;
      _score = 0;
      _streak = 0;
      _bestStreak = 0;
      _picked = null;
      _recorded = false;
    });
  }

  void _answer(int i) {
    if (_picked != null) return;
    final r = _deck[_index];
    final correct = r.options[i].id == r.answer.id;
    HapticFeedback.selectionClick();
    setState(() {
      _picked = i;
      if (correct) {
        _score++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
      } else {
        _streak = 0;
      }
    });
  }

  void _next() {
    setState(() {
      _index++;
      _picked = null;
    });
    if (_index >= _deck.length && !_recorded) {
      _recorded = true;
      final pct = (_score * 100 / _deck.length).round();
      context.read<SettingsProvider>().recordGame(pct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    if (_deck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tebak Benda')),
        body: const EmptyState(
          icon: Icons.hourglass_empty_rounded,
          title: 'Menyiapkan permainan',
          subtitle: 'Butuh minimal 4 artefak bawaan agar permainan berjalan.',
        ),
      );
    }
    final finished = _index >= _deck.length;
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: finished
              ? _result(context, p)
              : _round(context, p, _deck[_index]),
        ),
      ),
    );
  }

  Widget _round(BuildContext context, AppPalette p, _Round r) {
    final answered = _picked != null;
    final path = r.hard ? r.answer.bundledGallery[1] : r.answer.cover;
    return Column(
      key: ValueKey<int>(_index),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
              Expanded(
                child: Text('Tebakan ${_index + 1} dari ${_deck.length}',
                    style: AppText.display(context, size: 17)),
              ),
              const HelpButton(
                title: 'Cara bermain Tebak Benda',
                steps: [
                  'Lihat foto artefak, lalu ketuk salah satu dari 4 nama.',
                  'Jawaban benar menambah skor; beruntun tanpa salah menambah '
                      'streak.',
                  'Setiap soal ketiga adalah level sulit: hanya foto detail '
                      'permukaan yang ditampilkan.',
                  'Skor akhir dihitung dalam persen dan rekor terbaik '
                      'disimpan.',
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: p.soft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: p.primary),
                    const SizedBox(width: 3),
                    Text('$_score',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: p.primary)),
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
            child: LinearProgressIndicator(
              value: (_index + (answered ? 1 : 0)) / _deck.length,
              minHeight: 8,
              backgroundColor: p.soft,
              valueColor: AlwaysStoppedAnimation<Color>(p.primary),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ArtImage(path: path),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.op(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            r.hard ? 'Level sulit: foto detail' : 'Benda apakah ini?',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      if (_streak >= 2)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8862F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('$_streak beruntun',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < r.options.length; i++) _option(context, p, r, i),
              if (answered) ...[
                const SizedBox(height: 4),
                _reveal(context, r),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: answered ? _next : null,
              child: Text(
                  _index == _deck.length - 1 ? 'Lihat Hasil' : 'Berikutnya'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _option(BuildContext context, AppPalette p, _Round r, int i) {
    const green = Color(0xFF3F8A5C);
    const red = Color(0xFFD9534F);
    final opt = r.options[i];
    final isAnswer = opt.id == r.answer.id;
    final picked = _picked == i;
    Color border = p.border;
    Color bg = p.card;
    IconData? icon;
    if (_picked != null) {
      if (isAnswer) {
        border = green;
        bg = green.op(0.12);
        icon = Icons.check_circle_rounded;
      } else if (picked) {
        border = red;
        bg = red.op(0.10);
        icon = Icons.cancel_rounded;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _answer(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: _picked == null ? 1 : 1.6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(opt.name,
                    style: AppText.body(context,
                        size: 14.5, weight: FontWeight.w600)),
              ),
              if (icon != null)
                Icon(icon, color: isAnswer ? green : red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reveal(BuildContext context, _Round r) {
    final p = AppPalette.of(context);
    final a = r.answer;
    return SoftCard(
      color: p.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EraBadge(era: a.era),
              const SizedBox(width: 8),
              Text(a.ageBadge, style: AppText.muted(context)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            a.funFactList.isNotEmpty ? a.funFactList.first : a.functionPast,
            style: AppText.body(context, size: 13.5, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _result(BuildContext context, AppPalette p) {
    final pct = (_score * 100 / _deck.length).round();
    final best = context.watch<SettingsProvider>().gameBest;
    String title;
    if (pct >= 90) {
      title = 'Mata Elang!';
    } else if (pct >= 70) {
      title = 'Pengamat Tajam';
    } else if (pct >= 50) {
      title = 'Lumayan Jeli';
    } else {
      title = 'Terus Berlatih';
    }
    return ListView(
      key: const ValueKey<String>('result'),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 28),
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [p.heroStart, p.heroEnd],
              ),
            ),
            child: const Icon(Icons.visibility_rounded,
                color: Colors.white, size: 56),
          ),
        ),
        const SizedBox(height: 22),
        Text(title,
            textAlign: TextAlign.center,
            style: AppText.display(context, size: 27)),
        const SizedBox(height: 8),
        Text('$_score dari ${_deck.length} tebakan benar ($pct%)',
            textAlign: TextAlign.center,
            style: AppText.body(context, size: 15, color: p.muted)),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: SoftCard(
                color: p.soft,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  children: [
                    Text('$_bestStreak',
                        style: AppText.display(context, size: 22)),
                    Text('Beruntun terbaik',
                        style: AppText.muted(context, size: 11.5)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SoftCard(
                color: p.soft,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  children: [
                    Text('$best%', style: AppText.display(context, size: 22)),
                    Text('Rekor terbaik',
                        style: AppText.muted(context, size: 11.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        ElevatedButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.replay_rounded),
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
