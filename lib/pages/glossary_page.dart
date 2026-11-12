import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/glossary.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Glosarium istilah prasejarah: pencarian, filter kategori, dan
/// definisi singkat yang bisa dibuka.
class GlossaryPage extends StatefulWidget {
  const GlossaryPage({Key? key}) : super(key: key);

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  String _query = '';
  String? _category;
  String? _open;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) context.read<SettingsProvider>().markFlag('glossary');
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final categories = kGlossary.map((e) => e.category).toSet().toList()..sort();
    final q = _query.trim().toLowerCase();
    final list = kGlossary.where((t) {
      if (_category != null && t.category != _category) return false;
      if (q.isEmpty) return true;
      return '${t.term} ${t.definition}'.toLowerCase().contains(q);
    }).toList();

    // Kelompokkan per huruf awal.
    final groups = <String, List<GlossaryTerm>>{};
    for (final t in list) {
      groups.putIfAbsent(t.term[0].toUpperCase(), () => <GlossaryTerm>[]).add(t);
    }
    final letters = groups.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glosarium'),
        actions: const [
          HelpButton(
            title: 'Cara memakai Glosarium',
            steps: [
              'Ketik kata di kolom cari atau pilih kategori.',
              'Ketuk sebuah istilah untuk membuka artinya.',
              'Istilah yang sama juga muncul di halaman detail artefak.',
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: appInputDecoration(
                context,
                label: 'Cari istilah',
                prefix: Icon(Icons.search_rounded, color: p.muted),
              ),
            ),
          ),
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              children: [
                _Chip(
                    label: 'Semua',
                    selected: _category == null,
                    onTap: () => setState(() => _category = null)),
                for (final c in categories)
                  _Chip(
                      label: c,
                      selected: _category == c,
                      onTap: () => setState(
                          () => _category = _category == c ? null : c)),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const EmptyState(
                    icon: Icons.menu_book_outlined,
                    title: 'Istilah tidak ditemukan',
                    subtitle: 'Coba kata kunci lain.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('${list.length} istilah',
                            style: AppText.muted(context, size: 12.5)),
                      ),
                      for (final l in letters) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 10, 0, 8),
                          child: Text(l,
                              style: AppText.display(context,
                                  size: 20, color: p.primary)),
                        ),
                        for (final t in groups[l]!)
                          _TermCard(
                            term: t,
                            open: _open == t.term,
                            onTap: () => setState(
                                () => _open = _open == t.term ? null : t.term),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? p.primary : p.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? p.primary : p.border),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? p.onPrimary : p.text,
              )),
        ),
      ),
    );
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({
    required this.term,
    required this.open,
    required this.onTap,
  });

  final GlossaryTerm term;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SoftCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        radius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(term.term,
                      style: AppText.display(context, size: 15.5)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: p.soft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(term.category,
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: p.primary)),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: p.muted, size: 20),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: open
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(term.definition,
                          style: AppText.body(context, size: 13.5, height: 1.6)),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
