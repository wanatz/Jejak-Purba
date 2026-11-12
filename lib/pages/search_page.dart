import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../models/museum.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import '../widgets/museum_card.dart';
import 'detail_page.dart';
import 'explore_page.dart';
import 'museum_detail_page.dart';

/// Pencarian menyeluruh: artefak, museum, dan zaman sekaligus, dengan
/// filter jenis hasil (Semua / Artefak / Museum / Zaman).
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const List<String> _suggestions = [
    'kapak',
    'fosil',
    'Trinil',
    'perunggu',
    'gerabah',
    'batu',
    'tulang',
    'Pacitan',
  ];

  // Riwayat pencarian selama aplikasi berjalan.
  static final List<String> _recent = <String>[];

  final TextEditingController _ctrl = TextEditingController();
  String _query = '';
  int _type = 0; // 0 semua, 1 artefak, 2 museum, 3 zaman

  static const List<String> _types = ['Semua', 'Artefak', 'Museum', 'Zaman'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final v = value.trim();
    if (v.isEmpty) return;
    _recent.remove(v);
    _recent.insert(0, v);
    if (_recent.length > 6) _recent.removeLast();
  }

  void _useQuery(String q) {
    _ctrl.value = TextEditingValue(
      text: q,
      selection: TextSelection.collapsed(offset: q.length),
    );
    setState(() => _query = q);
    _submit(q);
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifacts = context.watch<ArtifactProvider>();
    final museums = context.watch<MuseumProvider>();
    final categories = context.watch<CategoryProvider>();
    final q = _query.trim().toLowerCase();

    final List<Artifact> artifactHits =
        q.isEmpty ? <Artifact>[] : artifacts.search(q);
    final List<Museum> museumHits = q.isEmpty
        ? <Museum>[]
        : museums.museums
            .where((m) => '${m.name} ${m.city} ${m.address} ${m.description}'
                .toLowerCase()
                .contains(q))
            .toList();
    final List<PrehistoricCategory> eraHits = q.isEmpty
        ? <PrehistoricCategory>[]
        : categories.categories
            .where((c) => '${c.name} ${c.description} ${c.tools} ${c.sites}'
                .toLowerCase()
                .contains(q))
            .toList();

    final showArtifacts = _type == 0 || _type == 1;
    final showMuseums = _type == 0 || _type == 2;
    final showEras = _type == 0 || _type == 3;
    final total = (showArtifacts ? artifactHits.length : 0) +
        (showMuseums ? museumHits.length : 0) +
        (showEras ? eraHits.length : 0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) => setState(() => _query = v),
                      onSubmitted: _submit,
                      decoration: InputDecoration(
                        hintText: 'Cari artefak, museum, atau zaman',
                        hintStyle: TextStyle(color: p.muted, fontSize: 14),
                        prefixIcon:
                            Icon(Icons.search_rounded, color: p.muted),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close_rounded, color: p.muted),
                                onPressed: () {
                                  _ctrl.clear();
                                  setState(() => _query = '');
                                },
                              ),
                        filled: true,
                        fillColor: p.card,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: p.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: p.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: p.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (q.isNotEmpty)
              SizedBox(
                height: 54,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                  children: [
                    for (var i = 0; i < _types.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _type = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _type == i ? p.primary : p.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _type == i ? p.primary : p.border),
                            ),
                            child: Text(
                              _types[i],
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: _type == i ? p.onPrimary : p.text,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: q.isEmpty
                  ? _Suggestions(
                      suggestions: _suggestions,
                      recent: _recent,
                      onPick: _useQuery,
                    )
                  : total == 0
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'Tidak ada hasil untuk "$_query"',
                          subtitle:
                              'Periksa ejaan atau coba kata yang lebih umum, '
                              'misalnya "kapak" atau "perunggu".',
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text('$total hasil ditemukan',
                                  style: AppText.muted(context, size: 13)),
                            ),
                            if (showArtifacts && artifactHits.isNotEmpty) ...[
                              _GroupLabel('Artefak (${artifactHits.length})'),
                              for (final a in artifactHits)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ArtifactCard(
                                    artifact: a,
                                    onTap: () {
                                      _submit(_query);
                                      openArtifactDetail(context, a);
                                    },
                                  ),
                                ),
                            ],
                            if (showMuseums && museumHits.isNotEmpty) ...[
                              _GroupLabel('Museum (${museumHits.length})'),
                              for (final m in museumHits)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: MuseumRowCard(
                                    museum: m,
                                    artifactCount:
                                        museums.artifactCount(m.name),
                                    onTap: () {
                                      _submit(_query);
                                      AppRoute.push(context,
                                          MuseumDetailPage(museumName: m.name));
                                    },
                                  ),
                                ),
                            ],
                            if (showEras && eraHits.isNotEmpty) ...[
                              _GroupLabel('Zaman (${eraHits.length})'),
                              for (final c in eraHits)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _EraResult(
                                    category: c,
                                    count: categories.countOf(c.name),
                                    onTap: () async {
                                      _submit(_query);
                                      final provider =
                                          context.read<ArtifactProvider>();
                                      provider.clearFilters();
                                      provider.setEra(c.name);
                                      await AppRoute.push(context,
                                          const ExplorePage(standalone: true));
                                      provider.clearFilters();
                                    },
                                  ),
                                ),
                            ],
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Text(text, style: AppText.display(context, size: 16)),
    );
  }
}

class _EraResult extends StatelessWidget {
  const _EraResult({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final PrehistoricCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: category.color.op(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(category.icon, color: category.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: AppText.display(context, size: 15.5)),
                Text('${category.range} · $count artefak',
                    style: AppText.muted(context, size: 11.5)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    required this.suggestions,
    required this.recent,
    required this.onPick,
  });

  final List<String> suggestions;
  final List<String> recent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        if (recent.isNotEmpty) ...[
          Text('Pencarian Terakhir', style: AppText.display(context, size: 16)),
          const SizedBox(height: 10),
          for (final r in recent)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.history_rounded, color: p.muted),
              title: Text(r),
              trailing:
                  Icon(Icons.north_west_rounded, size: 18, color: p.muted),
              onTap: () => onPick(r),
            ),
          const SizedBox(height: 18),
        ],
        Text('Coba Cari', style: AppText.display(context, size: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in suggestions)
              GestureDetector(
                onTap: () => onPick(s),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: p.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: p.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_rounded, size: 14, color: p.primary),
                      const SizedBox(width: 6),
                      Text(s,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
