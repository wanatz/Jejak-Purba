import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Kartu belajar: depan berisi foto dan nama, belakang berisi ringkasan.
/// Tandai "Hafal" atau "Ulangi" untuk memutar ulang kartu yang belum hafal.
class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  String? _era;
  List<Artifact> _deck = [];
  int _known = 0;
  int _total = 0;
  bool _flipped = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) context.read<SettingsProvider>().markFlag('cards');
    });
  }

  void _begin(String? era) {
    final items = context.read<ArtifactProvider>().artifacts.where((a) {
      return era == null || a.era == era;
    }).toList()
      ..shuffle();
    setState(() {
      _era = era;
      _deck = items;
      _known = 0;
      _total = items.length;
      _flipped = false;
      _started = true;
    });
  }

  void _mark(bool known) {
    if (_deck.isEmpty) return;
    setState(() {
      final card = _deck.removeAt(0);
      if (known) {
        _known++;
      } else {
        _deck.add(card);
      }
      _flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Belajar'),
        actions: [
          const HelpButton(
            title: 'Cara memakai Kartu Belajar',
            steps: [
              'Pilih deck: semua zaman atau satu zaman saja.',
              'Ketuk kartu untuk membaliknya dan melihat jawabannya.',
              'Ketuk Hafal bila sudah ingat, atau Ulangi bila belum.',
              'Kartu yang diulang akan muncul lagi sampai semuanya hafal.',
            ],
          ),
          if (_started)
            IconButton(
              tooltip: 'Ganti deck',
              onPressed: () => setState(() => _started = false),
              icon: const Icon(Icons.layers_rounded),
            ),
        ],
      ),
      body: _started ? _study(context, p) : _chooser(context, p),
    );
  }

  Widget _chooser(BuildContext context, AppPalette p) {
    final categories = context.watch<CategoryProvider>();
    final total = context.watch<ArtifactProvider>().totalArtifacts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Text(
          'Pilih deck. Balik kartu untuk melihat jawabannya, lalu tandai '
          'apakah kamu sudah hafal.',
          style: AppText.body(context, size: 14, color: p.muted),
        ),
        const SizedBox(height: 16),
        _DeckTile(
          title: 'Semua Zaman',
          subtitle: '$total kartu',
          icon: Icons.all_inclusive_rounded,
          color: p.primary,
          onTap: () => _begin(null),
        ),
        for (final c in categories.categories) ...[
          const SizedBox(height: 10),
          _DeckTile(
            title: c.name,
            subtitle: '${categories.countOf(c.name)} kartu · ${c.range}',
            icon: c.icon,
            color: c.color,
            onTap: () => _begin(c.name),
          ),
        ],
      ],
    );
  }

  Widget _study(BuildContext context, AppPalette p) {
    if (_deck.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3F8A5C).op(0.15),
                ),
                child: const Icon(Icons.verified_rounded,
                    size: 54, color: Color(0xFF3F8A5C)),
              ),
              const SizedBox(height: 18),
              Text('Semua kartu sudah hafal!',
                  textAlign: TextAlign.center,
                  style: AppText.display(context, size: 22)),
              const SizedBox(height: 8),
              Text('$_total kartu ${_era ?? 'semua zaman'} selesai dipelajari.',
                  textAlign: TextAlign.center,
                  style: AppText.muted(context, size: 13.5)),
              const SizedBox(height: 22),
              ElevatedButton(
                  onPressed: () => _begin(_era), child: const Text('Ulangi Deck')),
              const SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () => setState(() => _started = false),
                  child: const Text('Pilih Deck Lain')),
            ],
          ),
        ),
      );
    }
    final card = _deck.first;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Text('Hafal $_known / $_total',
                  style: AppText.body(context,
                      size: 13, weight: FontWeight.w700, color: p.primary)),
              const Spacer(),
              Text('Sisa ${_deck.length}',
                  style: AppText.muted(context, size: 12.5)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _total == 0 ? 0 : _known / _total,
              minHeight: 8,
              backgroundColor: p.soft,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3F8A5C)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: GestureDetector(
              onTap: () => setState(() => _flipped = !_flipped),
              child: TweenAnimationBuilder<double>(
                key: ValueKey<int?>(card.id),
                tween: Tween<double>(begin: 0, end: _flipped ? 1 : 0),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeInOut,
                builder: (context, v, _) {
                  final showFront = v < 0.5;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012)
                      ..rotateY(v * math.pi),
                    child: showFront
                        ? _Front(artifact: card)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: _Back(artifact: card),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          child: _flipped
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _mark(false),
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Ulangi'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _mark(true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F8A5C),
                            foregroundColor: Colors.white),
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Hafal'),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _flipped = true),
                    icon: const Icon(Icons.flip_rounded),
                    label: const Text('Balik Kartu'),
                  ),
                ),
        ),
      ],
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.op(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.display(context, size: 16)),
                Text(subtitle, style: AppText.muted(context, size: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: p.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.op(p.isDark ? 0.35 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ArtImage(path: artifact.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                EraBadge(era: artifact.era),
                const SizedBox(height: 10),
                Text(artifact.name,
                    textAlign: TextAlign.center,
                    style: AppText.display(context, size: 21, height: 1.2)),
                const SizedBox(height: 6),
                Text('Ketuk untuk membalik',
                    style: AppText.muted(context, size: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final color = EraStyle.color(artifact.era);
    Widget line(IconData icon, String label, String value) {
      if (value.trim().isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppText.muted(context,
                          size: 11, weight: FontWeight.w800)),
                  Text(value,
                      style: AppText.body(context, size: 13.5, height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color.op(p.isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.op(0.5), width: 1.5),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(artifact.name,
              style: AppText.display(context, size: 19, color: color)),
          const SizedBox(height: 14),
          line(Icons.hourglass_bottom_rounded, 'USIA', artifact.period),
          line(Icons.diamond_outlined, 'BAHAN', artifact.material),
          line(Icons.place_outlined, 'ASAL', artifact.origin),
          line(Icons.handyman_outlined, 'FUNGSI DULU', artifact.functionPast),
          if (artifact.funFactList.isNotEmpty)
            line(Icons.lightbulb_outline_rounded, 'FAKTA',
                artifact.funFactList.first),
        ],
      ),
    );
  }
}
