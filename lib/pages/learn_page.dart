import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/glossary.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../providers/settings_provider.dart';
import '../services/achievements.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'achievements_page.dart';
import 'compare_page.dart';
import 'explore_page.dart';
import 'flashcards_page.dart';
import 'glossary_page.dart';
import 'guess_game_page.dart';
import 'map_page.dart';
import 'quiz_page.dart';
import 'scholars_page.dart';
import 'timeline_page.dart';

/// Pusat belajar: semua fitur edukasi dalam satu tempat.
class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final categories = context.watch<CategoryProvider>();
    final settings = context.watch<SettingsProvider>();
    final badges = Achievements.build(
      artifacts: context.watch<ArtifactProvider>(),
      museums: context.watch<MuseumProvider>(),
      settings: settings,
    );
    final unlocked = badges.where((b) => b.unlocked).length;

    final features = <_Feature>[
      _Feature(
        icon: Icons.map_rounded,
        title: 'Peta Situs',
        subtitle: 'Lokasi temuan & museum',
        color: const Color(0xFF3F8A78),
        onTap: () => AppRoute.push(context, const MapPage()),
      ),
      _Feature(
        icon: Icons.timeline_rounded,
        title: 'Linimasa',
        subtitle: '5 zaman prasejarah',
        color: const Color(0xFF8A5A3B),
        onTap: () => AppRoute.push(context, const TimelinePage()),
      ),
      _Feature(
        icon: Icons.quiz_rounded,
        title: 'Kuis',
        subtitle: settings.quizPlays == 0
            ? '10 soal acak'
            : 'Rekor ${settings.quizBest}%',
        color: const Color(0xFFB8862F),
        onTap: () => AppRoute.push(context, const QuizPage()),
      ),
      _Feature(
        icon: Icons.visibility_rounded,
        title: 'Tebak Benda',
        subtitle: settings.gameBest == 0
            ? 'Tebak dari fotonya'
            : 'Rekor ${settings.gameBest}%',
        color: const Color(0xFFA4513A),
        onTap: () => AppRoute.push(context, const GuessGamePage()),
      ),
      _Feature(
        icon: Icons.style_rounded,
        title: 'Kartu Belajar',
        subtitle: 'Balik & hafalkan',
        color: const Color(0xFF6B8A45),
        onTap: () => AppRoute.push(context, const FlashcardsPage()),
      ),
      _Feature(
        icon: Icons.compare_rounded,
        title: 'Bandingkan',
        subtitle: 'Dua artefak sekaligus',
        color: const Color(0xFF7B5133),
        onTap: () => AppRoute.push(context, const ComparePage()),
      ),
      _Feature(
        icon: Icons.menu_book_rounded,
        title: 'Glosarium',
        subtitle: '${kGlossary.length} istilah penting',
        color: const Color(0xFF3F8A78),
        onTap: () => AppRoute.push(context, const GlossaryPage()),
      ),
      _Feature(
        icon: Icons.groups_2_rounded,
        title: 'Tokoh Peneliti',
        subtitle: 'Dubois & kawan-kawan',
        color: const Color(0xFF8A5A3B),
        onTap: () => AppRoute.push(context, const ScholarsPage()),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            Text('Belajar', style: AppText.display(context, size: 26)),
            const SizedBox(height: 4),
            Text('Tempat bermain sambil mengenal prasejarah.',
                style: AppText.muted(context, size: 13.5)),
            const SizedBox(height: 16),
            SoftCard(
              onTap: () => AppRoute.push(context, const AchievementsPage()),
              color: p.soft,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB8862F),
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pencapaian',
                            style: AppText.display(context, size: 16)),
                        const SizedBox(height: 2),
                        Text('$unlocked dari ${badges.length} lencana terbuka',
                            style: AppText.muted(context, size: 12.5)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: unlocked / badges.length,
                            minHeight: 6,
                            backgroundColor: p.card,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFB8862F)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: p.muted),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 132,
              ),
              itemCount: features.length,
              itemBuilder: (context, i) => FadeSlideIn(
                delay: staggerDelay(i, stepMs: 45),
                child: _FeatureCard(feature: features[i]),
              ),
            ),
            const SizedBox(height: 26),
            Text('Kenali Zaman', style: AppText.display(context, size: 19)),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final c = categories.categories[i];
                  return _EraScene(
                    category: c,
                    count: categories.countOf(c.name),
                    onTap: () async {
                      final provider = context.read<ArtifactProvider>();
                      provider.clearFilters();
                      provider.setEra(c.name);
                      await AppRoute.push(
                          context, const ExplorePage(standalone: true));
                      provider.clearFilters();
                    },
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

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: feature.onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: feature.color.op(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(feature.icon, color: feature.color, size: 25),
          ),
          const Spacer(),
          Text(feature.title, style: AppText.display(context, size: 16)),
          const SizedBox(height: 2),
          Text(feature.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.muted(context, size: 11.5)),
        ],
      ),
    );
  }
}

class _EraScene extends StatelessWidget {
  const _EraScene({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final PrehistoricCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 250,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ArtImage(path: AppAssets.eraScene(category.name)),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xCC000000)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name,
                        style: AppText.display(context,
                            size: 18, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('$count artefak · ${category.range}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.op(0.85), fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
