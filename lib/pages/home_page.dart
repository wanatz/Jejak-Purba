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
import 'admin_page.dart';
import 'guess_game_page.dart';
import 'map_page.dart';
import 'detail_page.dart';
import 'museum_detail_page.dart';
import 'quiz_page.dart';
import 'search_page.dart';
import 'timeline_page.dart';

/// Beranda: banner, pencarian, artefak pilihan, fakta menarik, zaman,
/// museum, dan pintasan fitur.
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.onOpenTab}) : super(key: key);

  /// Pindah tab utama (0 Beranda, 1 Jelajah, 2 Favorit, 3 Profil).
  final ValueChanged<int> onOpenTab;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _factShift = 0;

  void _openExplore({String? era}) {
    final provider = context.read<ArtifactProvider>();
    provider.clearFilters();
    provider.setEra(era);
    widget.onOpenTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifacts = context.watch<ArtifactProvider>();
    final categories = context.watch<CategoryProvider>();
    final museums = context.watch<MuseumProvider>();

    final featured = artifacts.featured(count: 6);
    final facts = artifacts.facts;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            _Header(onSearch: () => AppRoute.push(context, const SearchPage())),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: FadeSlideIn(child: _HeroBanner(onExplore: () => _openExplore())),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: FadeSlideIn(delay: const Duration(milliseconds: 90), child: _FakeSearchBar(
                  onTap: () => AppRoute.push(context, const SearchPage()))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.inventory_2_outlined,
                      value: '${artifacts.totalArtifacts}',
                      label: 'Artefak',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.account_balance_outlined,
                      value: '${museums.totalMuseums}',
                      label: 'Museum',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.hourglass_bottom_rounded,
                      value: '${categories.totalCategories}',
                      label: 'Zaman',
                    ),
                  ),
                ],
              ),
            ),

            // ---- Artefak pilihan ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
              child: SectionHeader(
                title: 'Artefak Pilihan',
                subtitle: 'Berganti setiap hari',
                onSeeAll: () => _openExplore(),
              ),
            ),
            SizedBox(
              height: 214,
              child: featured.isEmpty
                  ? const _SkeletonRow()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featured.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final a = featured[i];
                        return FadeSlideIn(delay: staggerDelay(i), child: ArtifactTile(
                          artifact: a,
                          onTap: () => openArtifactDetail(context, a),
                        ));
                      },
                    ),
            ),

            // ---- Terakhir dilihat ----
            if (artifacts.viewedArtifacts(limit: 8).isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: const SectionHeader(
                  title: 'Terakhir Dilihat',
                  subtitle: 'Lanjutkan dari tempat terakhirmu',
                ),
              ),
              SizedBox(
                height: 214,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: artifacts.viewedArtifacts(limit: 8).length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final a = artifacts.viewedArtifacts(limit: 8)[i];
                    return FadeSlideIn(delay: staggerDelay(i), child: ArtifactTile(
                      artifact: a,
                      onTap: () => openArtifactDetail(context, a),
                    ));
                  },
                ),
              ),
            ],

            // ---- Tahukah kamu ----
            if (facts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: FadeSlideIn(delay: const Duration(milliseconds: 120), child: _FactCard(
                  fact: facts[(DateTime.now().day + _factShift) % facts.length],
                  onNext: () => setState(() => _factShift++),
                  onOpen: (a) => openArtifactDetail(context, a),
                )),
              ),

            // ---- Zaman ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: SectionHeader(
                title: 'Zaman Prasejarah',
                subtitle: 'Dari batu tua hingga logam',
                onSeeAll: () => AppRoute.push(context, const TimelinePage()),
                seeAllLabel: 'Linimasa',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final c in categories.categories) ...[
                    _EraTile(
                      category: c,
                      count: categories.countOf(c.name),
                      onTap: () => _openExplore(era: c.name),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),

            // ---- Museum ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: SectionHeader(
                title: 'Museum di Jawa Timur',
                subtitle: 'Tempat koleksi ini tersimpan',
                onSeeAll: () {
                  context.read<ArtifactProvider>().clearFilters();
                  widget.onOpenTab(1);
                },
              ),
            ),
            SizedBox(
              height: 232,
              child: museums.museums.isEmpty
                  ? const _SkeletonRow()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: museums.museums.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final m = museums.museums[i];
                        return FadeSlideIn(delay: staggerDelay(i), child: MuseumCard(
                          museum: m,
                          artifactCount: museums.artifactCount(m.name),
                          onTap: () => AppRoute.push(
                              context, MuseumDetailPage(museumName: m.name)),
                        ));
                      },
                    ),
            ),

            // ---- Pintasan ----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
              child: SectionHeader(
                title: 'Belajar & Bermain',
                subtitle: 'Peta, permainan, dan kuis',
                onSeeAll: () => widget.onOpenTab(2),
                seeAllLabel: 'Semua',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.map_rounded,
                      label: 'Peta',
                      color: const Color(0xFF3F8A78),
                      onTap: () => AppRoute.push(context, const MapPage()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.visibility_rounded,
                      label: 'Tebak',
                      color: const Color(0xFFA4513A),
                      onTap: () =>
                          AppRoute.push(context, const GuessGamePage()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.quiz_rounded,
                      label: 'Kuis',
                      color: const Color(0xFFB8862F),
                      onTap: () => AppRoute.push(context, const QuizPage()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShortcutTile(
                      icon: Icons.add_photo_alternate_rounded,
                      label: 'Tambah',
                      color: const Color(0xFF6B8A45),
                      onTap: () => AppRoute.push(context, const AdminPage()),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
              child: Column(
                children: [
                  Icon(Icons.landscape_rounded,
                      color: p.muted.op(0.6), size: 26),
                  const SizedBox(height: 8),
                  Text(
                    'Bersama kita lestarikan\njejak peradaban Nusantara.',
                    textAlign: TextAlign.center,
                    style: AppText.display(context,
                        size: 14,
                        weight: FontWeight.w500,
                        color: p.muted,
                        height: 1.45),
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

class _Header extends StatelessWidget {
  const _Header({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [p.heroStart, p.heroEnd],
              ),
            ),
            child: const Icon(Icons.landscape_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppInfo.name, style: AppText.display(context, size: 21)),
                Text(AppInfo.subtitle,
                    style: AppText.muted(context, size: 12)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cari',
            onPressed: onSearch,
            icon: Icon(Icons.search_rounded, color: p.text),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 252,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ArtImage(path: AppAssets.hero),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xDD3B2416), Color(0x663B2416), Color(0x00000000)],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.op(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'KOLEKSI PRASEJARAH JATIM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Telusuri Jejak\nNenek Moyang',
                    style: AppText.display(context,
                        size: 29, color: Colors.white, height: 1.15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Artefak, fosil, dan kisah di baliknya.',
                    style: TextStyle(
                      color: Colors.white.op(0.88),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF583521),
                    ),
                    icon: const Text('Jelajahi Sekarang'),
                    label: const Icon(Icons.arrow_forward_rounded, size: 18),
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

class _FakeSearchBar extends StatelessWidget {
  const _FakeSearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.border),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: p.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Cari kapak, fosil, Trinil, perunggu...',
                  style: AppText.muted(context, size: 14)),
            ),
            Icon(Icons.tune_rounded, color: p.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      color: p.soft,
      child: Column(
        children: [
          Icon(icon, color: p.primary, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppText.display(context, size: 22)),
          Text(label, style: AppText.muted(context, size: 12)),
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.fact,
    required this.onNext,
    required this.onOpen,
  });

  final ArtifactFact fact;
  final VoidCallback onNext;
  final ValueChanged<Artifact> onOpen;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final color = EraStyle.color(fact.artifact.era);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: color.op(p.isDark ? 0.18 : 0.10),
        border: Border.all(color: color.op(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    color: Colors.white, size: 19),
              ),
              const SizedBox(width: 10),
              Text('Tahukah Kamu?',
                  style: AppText.display(context, size: 17)),
              const Spacer(),
              GestureDetector(
                onTap: onNext,
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 16, color: color),
                    const SizedBox(width: 3),
                    Text('Fakta lain',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              fact.text,
              key: ValueKey<String>(fact.text),
              style: AppText.body(context, size: 14.5, height: 1.55),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => onOpen(fact.artifact),
            child: Row(
              children: [
                Icon(Icons.north_east_rounded, size: 15, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Dari: ${fact.artifact.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EraTile extends StatelessWidget {
  const _EraTile({
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
    final color = category.color;
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.op(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style: AppText.display(context, size: 16)),
                const SizedBox(height: 2),
                Text(category.range,
                    style: AppText.muted(context, size: 11.5)),
                const SizedBox(height: 3),
                Text(category.highlight,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(context,
                        size: 12.5, color: p.text.op(0.8))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: color.op(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$count',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: color, fontSize: 13)),
          ),
          Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.op(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: AppText.body(context,
                  size: 13, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Placeholder abu-abu saat data masih dimuat.
class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Container(
        width: 164,
        decoration: BoxDecoration(
          color: p.soft,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
