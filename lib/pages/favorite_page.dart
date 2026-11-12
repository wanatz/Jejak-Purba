import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../providers/museum_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import '../widgets/museum_card.dart';
import 'detail_page.dart';
import 'museum_detail_page.dart';

/// Daftar favorit dalam dua tab: Artefak dan Museum.
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifacts = context.watch<ArtifactProvider>();
    final museums = context.watch<MuseumProvider>();
    final favArtifacts = artifacts.favoriteArtifacts;
    final favMuseums = museums.favoriteMuseums;

    return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Favorit',
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
                        '${favArtifacts.length + favMuseums.length} tersimpan',
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: SegmentedTabs(
                  controller: _tabs,
                  labels: ['Artefak (${favArtifacts.length})', 'Museum (${favMuseums.length})'],
                  icons: const [Icons.diamond_outlined, Icons.account_balance_outlined],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    favArtifacts.isEmpty
                        ? const EmptyState(
                            icon: Icons.favorite_border_rounded,
                            title: 'Belum ada artefak favorit',
                            subtitle:
                                'Ketuk ikon hati pada artefak untuk '
                                'menyimpannya di sini.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount: favArtifacts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final a = favArtifacts[i];
                              return ArtifactCard(
                                artifact: a,
                                onTap: () => openArtifactDetail(context, a),
                                onToggleFavorite: () => context
                                    .read<ArtifactProvider>()
                                    .toggleFavorite(a),
                              );
                            },
                          ),
                    favMuseums.isEmpty
                        ? const EmptyState(
                            icon: Icons.account_balance_outlined,
                            title: 'Belum ada museum favorit',
                            subtitle:
                                'Buka halaman museum lalu ketuk ikon hati.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount: favMuseums.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final m = favMuseums[i];
                              return MuseumRowCard(
                                museum: m,
                                artifactCount: museums.artifactCount(m.name),
                                isFavorite: true,
                                onToggleFavorite: () =>
                                    museums.toggleFavorite(m.name),
                                onTap: () => AppRoute.push(context,
                                    MuseumDetailPage(museumName: m.name)),
                              );
                            },
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
