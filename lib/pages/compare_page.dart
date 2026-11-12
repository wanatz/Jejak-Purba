import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Membandingkan dua artefak berdampingan: foto, zaman, usia, bahan,
/// ukuran, budaya, asal, dan museum.
class ComparePage extends StatefulWidget {
  const ComparePage({Key? key, this.initialId}) : super(key: key);

  final int? initialId;

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  int? _a;
  int? _b;

  @override
  void initState() {
    super.initState();
    _a = widget.initialId;
  }

  Future<void> _pick(bool first) async {
    final items = context.read<ArtifactProvider>().artifacts;
    final exclude = first ? _b : _a;
    final chosen = await showModalBottomSheet<Artifact>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.of(context).bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => _PickerSheet(
        items: items.where((a) => a.id != exclude).toList(),
      ),
    );
    if (chosen == null) return;
    setState(() {
      if (first) {
        _a = chosen.id;
      } else {
        _b = chosen.id;
      }
    });
    if (_a != null && _b != null && mounted) {
      context.read<SettingsProvider>().markFlag('compare');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();
    final a = provider.findById(_a);
    final b = provider.findById(_b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bandingkan Artefak'),
        actions: const [
          HelpButton(
            title: 'Cara membandingkan',
            steps: [
              'Ketuk kotak kiri dan kanan untuk memilih dua artefak.',
              'Batang usia memperlihatkan siapa yang lebih tua.',
              'Baris yang bergaris warna berarti kedua artefak berbeda di '
                  'bagian itu; "sama" berarti nilainya serupa.',
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Row(
            children: [
              Expanded(child: _Slot(artifact: a, onTap: () => _pick(true))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: p.primary, shape: BoxShape.circle),
                  child: Text('VS',
                      style: TextStyle(
                          color: p.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12)),
                ),
              ),
              Expanded(child: _Slot(artifact: b, onTap: () => _pick(false))),
            ],
          ),
          const SizedBox(height: 22),
          if (a == null || b == null)
            SoftCard(
              color: p.soft,
              child: Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: p.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ketuk kedua kotak di atas untuk memilih dua artefak '
                      'yang ingin dibandingkan.',
                      style: AppText.body(context, size: 13.5, height: 1.5),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            _AgeBars(a: a, b: b),
            const SizedBox(height: 16),
            _row(context, Icons.hourglass_bottom_rounded, 'Zaman', a.era, b.era),
            _row(context, Icons.schedule_rounded, 'Usia', a.period, b.period),
            _row(context, Icons.diamond_outlined, 'Bahan', a.material, b.material),
            _row(context, Icons.straighten_rounded, 'Ukuran',
                a.dimensions, b.dimensions),
            _row(context, Icons.groups_2_outlined, 'Budaya', a.culture, b.culture),
            _row(context, Icons.place_outlined, 'Asal temuan', a.origin, b.origin),
            _row(context, Icons.account_balance_outlined, 'Museum',
                a.museum, b.museum),
            _row(context, Icons.event_outlined, 'Tahun temuan',
                a.discoveryYear, b.discoveryYear),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String va,
      String vb) {
    final p = AppPalette.of(context);
    final same = va.trim().toLowerCase() == vb.trim().toLowerCase();
    String show(String v) => v.trim().isEmpty ? '-' : v;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: same ? p.border : p.primary.op(0.5)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: p.primary),
                const SizedBox(width: 6),
                Text(label,
                    style: AppText.muted(context,
                        size: 11.5, weight: FontWeight.w800)),
                const Spacer(),
                if (same)
                  Text('sama',
                      style: AppText.muted(context, size: 10.5)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(show(va),
                      style: AppText.body(context,
                          size: 13, weight: FontWeight.w600, height: 1.4)),
                ),
                Container(
                    width: 1,
                    height: 34,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: p.border),
                Expanded(
                  child: Text(show(vb),
                      style: AppText.body(context,
                          size: 13, weight: FontWeight.w600, height: 1.4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.artifact, required this.onTap});

  final Artifact? artifact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    if (artifact == null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            color: p.soft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_rounded, size: 34, color: p.primary),
              const SizedBox(height: 8),
              Text('Pilih artefak',
                  style: AppText.body(context,
                      size: 13, weight: FontWeight.w700, color: p.primary)),
            ],
          ),
        ),
      );
    }
    final a = artifact!;
    return SoftCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 190,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ArtImage(path: a.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(a.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display(context, size: 13.5, height: 1.2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgeBars extends StatelessWidget {
  const _AgeBars({required this.a, required this.b});

  final Artifact a;
  final Artifact b;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final maxAge = [a.ageYears, b.ageYears, 1].reduce((x, y) => x > y ? x : y);
    Widget bar(Artifact x) {
      final f = x.ageYears <= 0 ? 0.03 : (x.ageYears / maxAge).clamp(0.03, 1.0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(x.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(context,
                        size: 12.5, weight: FontWeight.w700)),
              ),
              Text(x.ageBadge,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: EraStyle.color(x.era))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: f.toDouble()),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 12,
                backgroundColor: p.soft,
                valueColor:
                    AlwaysStoppedAnimation<Color>(EraStyle.color(x.era)),
              ),
            ),
          ),
        ],
      );
    }

    return SoftCard(
      color: p.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, size: 18, color: p.primary),
              const SizedBox(width: 8),
              Text('Siapa yang lebih tua?',
                  style: AppText.display(context, size: 15.5)),
            ],
          ),
          const SizedBox(height: 14),
          bar(a),
          const SizedBox(height: 12),
          bar(b),
        ],
      ),
    );
  }
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({required this.items});

  final List<Artifact> items;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final list = widget.items
        .where((a) => ArtifactProvider.matches(a, _q))
        .toList();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: p.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: TextField(
                onChanged: (v) => setState(() => _q = v),
                decoration: appInputDecoration(context,
                    label: 'Cari artefak',
                    prefix: Icon(Icons.search_rounded, color: p.muted)),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final a = list[i];
                  return SoftCard(
                    padding: const EdgeInsets.all(8),
                    onTap: () => Navigator.of(context).pop(a),
                    child: Row(
                      children: [
                        ArtImage(
                            path: a.cover, width: 54, height: 54, radius: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.body(context,
                                      size: 14, weight: FontWeight.w700)),
                              Text('${a.era} · ${a.ageBadge}',
                                  style: AppText.muted(context, size: 11.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
