import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../providers/museum_provider.dart';
import '../providers/settings_provider.dart';
import '../services/achievements.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Pencapaian: lencana yang terbuka seiring penggunaan aplikasi.
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final list = Achievements.build(
      artifacts: context.watch<ArtifactProvider>(),
      museums: context.watch<MuseumProvider>(),
      settings: context.watch<SettingsProvider>(),
    );
    final unlocked = list.where((a) => a.unlocked).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [p.heroStart, p.heroEnd],
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 78,
                  height: 78,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 78,
                        height: 78,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0, end: unlocked / list.length),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, v, _) => CircularProgressIndicator(
                            value: v,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.op(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                      ),
                      Text('$unlocked',
                          style: AppText.display(context,
                              size: 26, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$unlocked dari ${list.length} lencana',
                          style: AppText.display(context,
                              size: 18, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        unlocked == list.length
                            ? 'Semua terbuka. Kamu hebat!'
                            : 'Jelajahi dan belajar untuk membuka lencana lain.',
                        style: TextStyle(
                            color: Colors.white.op(0.85),
                            fontSize: 12.5,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 168,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) => _BadgeCard(a: list[i]),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.a});

  final Achievement a;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final on = a.unlocked;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: on ? a.color.op(p.isDark ? 0.18 : 0.10) : p.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: on ? a.color.op(0.6) : p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: on ? a.color : p.soft,
                ),
                child: Icon(a.icon,
                    color: on ? Colors.white : p.muted, size: 24),
              ),
              const Spacer(),
              if (on)
                Icon(Icons.verified_rounded, color: a.color, size: 22)
              else
                Icon(Icons.lock_outline_rounded, color: p.muted, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(a.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.display(context, size: 14.5)),
          const SizedBox(height: 3),
          Expanded(
            child: Text(a.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.muted(context, size: 11.5)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: a.fraction,
              minHeight: 6,
              backgroundColor: p.soft,
              valueColor: AlwaysStoppedAnimation<Color>(a.color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            on ? 'Terbuka' : '${a.progress}/${a.target}',
            style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: on ? a.color : p.muted),
          ),
        ],
      ),
    );
  }
}
