import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import '../widgets/museum_card.dart';
import 'detail_page.dart';
import 'museum_detail_page.dart';

/// Halaman Jelajah: dua tab (Artefak & Museum). Tab Artefak punya pencarian,
/// filter zaman, pengurutan, dan tampilan grid/daftar.
///
/// Bisa dipakai sebagai tab utama maupun halaman tersendiri ([standalone]).
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, this.standalone = false, this.initialTab = 0})
      : super(key: key);

  final bool standalone;
  final int initialTab;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _museumCtrl = TextEditingController();
  String _museumQuery = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTab.clamp(0, 1));
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _searchCtrl.text = context.read<ArtifactProvider>().searchQuery;
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchCtrl.dispose();
    _museumCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();

    // Sinkronkan kolom cari bila filter diubah dari luar (mis. dari Beranda).
    if (_searchCtrl.text != provider.searchQuery) {
      _searchCtrl.value = TextEditingValue(
        text: provider.searchQuery,
        selection:
            TextSelection.collapsed(offset: provider.searchQuery.length),
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(widget.standalone ? 6 : 20, 10, 20, 0),
              child: Row(
                children: [
                  if (widget.standalone)
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  Expanded(
                    child: Text('Jelajah',
                        style: AppText.display(context, size: 26)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: p.soft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _tabs.index == 0
                          ? '${provider.filteredArtifacts.length} artefak'
                          : '${context.watch<MuseumProvider>().totalMuseums} museum',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: p.primary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: SegmentedTabs(
                controller: _tabs,
                labels: const ['Artefak', 'Museum'],
                icons: const [
                  Icons.diamond_outlined,
                  Icons.account_balance_outlined
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _ArtifactTab(controller: _searchCtrl),
                  _MuseumTab(
                    controller: _museumCtrl,
                    query: _museumQuery,
                    onQuery: (v) => setState(() => _museumQuery = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtifactTab extends StatelessWidget {
  const _ArtifactTab({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();
    final categories = context.watch<CategoryProvider>();
    final items = provider.filteredArtifacts;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: TextField(
            controller: controller,
            onChanged: provider.setSearchQuery,
            textInputAction: TextInputAction.search,
            decoration: _searchDecoration(
              context,
              hint: 'Cari nama, bahan, atau asal temuan',
              onClear: controller.text.isEmpty
                  ? null
                  : () {
                      controller.clear();
                      provider.setSearchQuery('');
                    },
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            children: [
              _FilterChip(
                label: 'Semua',
                selected: provider.selectedEra == null,
                onTap: () => provider.setEra(null),
              ),
              for (final c in categories.categories)
                _FilterChip(
                  label: c.name,
                  color: c.color,
                  selected: provider.selectedEra == c.name,
                  onTap: () => provider.setEra(
                      provider.selectedEra == c.name ? null : c.name),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 12, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  provider.selectedEra == null
                      ? 'Semua zaman'
                      : provider.selectedEra!,
                  style: AppText.muted(context, size: 13),
                ),
              ),
              PopupMenuButton<ArtifactSort>(
                tooltip: 'Urutkan',
                initialValue: provider.sort,
                onSelected: provider.setSort,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                itemBuilder: (_) => [
                  for (final s in ArtifactSort.values)
                    PopupMenuItem<ArtifactSort>(
                        value: s, child: Text(s.label)),
                ],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.swap_vert_rounded, size: 18, color: p.primary),
                      const SizedBox(width: 4),
                      Text(provider.sort.label,
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: p.primary)),
                    ],
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Filter lanjutan',
                    onPressed: () => _showFilterSheet(context),
                    icon: Icon(Icons.tune_rounded, color: p.primary, size: 22),
                  ),
                  if (provider.advancedFilterCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9534F),
                          shape: BoxShape.circle,
                        ),
                        child: Text('${provider.advancedFilterCount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                ],
              ),
              IconButton(
                tooltip: provider.gridView ? 'Tampilan daftar' : 'Tampilan grid',
                onPressed: () => provider.setGridView(!provider.gridView),
                icon: Icon(
                  provider.gridView
                      ? Icons.view_agenda_outlined
                      : Icons.grid_view_rounded,
                  color: p.primary,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Artefak tidak ditemukan',
                  subtitle:
                      'Coba kata kunci lain atau hapus filter zaman yang aktif.',
                  actionLabel: 'Reset filter',
                  onAction: () {
                    controller.clear();
                    provider.clearFilters();
                  },
                )
              : provider.gridView
                  ? _ArtifactGrid(items: items)
                  : _ArtifactList(items: items),
        ),
      ],
    );
  }
}

class _ArtifactGrid extends StatelessWidget {
  const _ArtifactGrid({required this.items});

  final List<Artifact> items;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ArtifactProvider>();
    return LayoutBuilder(
      builder: (context, c) {
        final cardWidth = (c.maxWidth - 40 - 12) / 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: cardWidth * 0.75 + 104,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final a = items[i];
            return FadeSlideIn(delay: staggerDelay(i), child: ArtifactGridCard(
              artifact: a,
              onTap: () => openArtifactDetail(context, a),
              onToggleFavorite: () => provider.toggleFavorite(a),
            ));
          },
        );
      },
    );
  }
}

class _ArtifactList extends StatelessWidget {
  const _ArtifactList({required this.items});

  final List<Artifact> items;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ArtifactProvider>();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final a = items[i];
        return FadeSlideIn(delay: staggerDelay(i), child: ArtifactCard(
          artifact: a,
          onTap: () => openArtifactDetail(context, a),
          onToggleFavorite: () => provider.toggleFavorite(a),
        ));
      },
    );
  }
}

class _MuseumTab extends StatelessWidget {
  const _MuseumTab({
    required this.controller,
    required this.query,
    required this.onQuery,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final museums = context.watch<MuseumProvider>();
    final q = query.trim().toLowerCase();
    final list = museums.museums.where((m) {
      if (q.isEmpty) return true;
      return '${m.name} ${m.city} ${m.address}'.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: TextField(
            controller: controller,
            onChanged: onQuery,
            decoration: _searchDecoration(
              context,
              hint: 'Cari museum atau kota',
              onClear: controller.text.isEmpty
                  ? null
                  : () {
                      controller.clear();
                      onQuery('');
                    },
            ),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const EmptyState(
                  icon: Icons.account_balance_outlined,
                  title: 'Museum tidak ditemukan',
                  subtitle: 'Coba nama museum atau kota yang lain.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final m = list[i];
                    return MuseumRowCard(
                      museum: m,
                      artifactCount: museums.artifactCount(m.name),
                      isFavorite: museums.isFavorite(m.name),
                      onToggleFavorite: () => museums.toggleFavorite(m.name),
                      onTap: () => AppRoute.push(
                          context, MuseumDetailPage(museumName: m.name)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final c = color ?? p.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c : p.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? c : p.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : p.text,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dekorasi kolom pencarian yang dipakai bersama.
InputDecoration _searchDecoration(
  BuildContext context, {
  required String hint,
  VoidCallback? onClear,
}) {
  final p = AppPalette.of(context);
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: p.muted, fontSize: 14),
    prefixIcon: Icon(Icons.search_rounded, color: p.muted),
    suffixIcon: onClear == null
        ? null
        : IconButton(
            icon: Icon(Icons.close_rounded, color: p.muted),
            onPressed: onClear,
          ),
    filled: true,
    fillColor: p.card,
    contentPadding: const EdgeInsets.symmetric(vertical: 14),
    border: border(p.border),
    enabledBorder: border(p.border),
    focusedBorder: border(p.primary),
  );
}

/// Lembar filter lanjutan: kelompok bahan, museum, dan hanya favorit.
void _showFilterSheet(BuildContext context) {
  final p = AppPalette.of(context);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: p.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (ctx) {
      final provider = ctx.watch<ArtifactProvider>();
      final museums = ctx.watch<MuseumProvider>().museums;

      Widget chip(String label, bool selected, VoidCallback onTap) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
        );
      }

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text('Filter Lanjutan',
                        style: AppText.display(ctx, size: 20)),
                  ),
                  if (provider.advancedFilterCount > 0)
                    TextButton(
                      onPressed: provider.clearAdvancedFilters,
                      child: const Text('Reset'),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text('Bahan', style: AppText.display(ctx, size: 15.5)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final g in ArtifactProvider.materialGroups)
                    chip(
                      g,
                      provider.selectedMaterial == g,
                      () => provider.setMaterial(
                          provider.selectedMaterial == g ? null : g),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Museum', style: AppText.display(ctx, size: 15.5)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final m in museums)
                    chip(
                      m.name,
                      provider.selectedMuseum == m.name,
                      () => provider.setMuseum(
                          provider.selectedMuseum == m.name ? null : m.name),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              SoftCard(
                onTap: () => provider.setFavoritesOnly(!provider.favoritesOnly),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.favorite_rounded,
                        color: const Color(0xFFD9534F).op(0.9), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Hanya favorit',
                          style: AppText.body(ctx,
                              size: 14, weight: FontWeight.w700)),
                    ),
                    Icon(
                      provider.favoritesOnly
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: provider.favoritesOnly ? p.primary : p.muted,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                      'Tampilkan ${provider.filteredArtifacts.length} artefak'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
