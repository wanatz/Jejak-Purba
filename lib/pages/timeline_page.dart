import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'explore_page.dart';

/// Linimasa lima zaman prasejarah. Setiap zaman bisa dibuka untuk melihat
/// cara hidup, alat, manusia, dan situs penting, lalu menuju artefaknya.
class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _open = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) context.read<SettingsProvider>().markFlag('timeline');
    });
  }

  Future<void> _openEra(String era) async {
    final provider = context.read<ArtifactProvider>();
    provider.clearFilters();
    provider.setEra(era);
    await AppRoute.push(context, const ExplorePage(standalone: true));
    provider.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final categories = context.watch<CategoryProvider>();
    final list = categories.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linimasa Zaman'),
        actions: const [
          HelpButton(
            title: 'Cara membaca Linimasa',
            steps: [
              'Zaman disusun dari yang paling tua (atas) ke yang paling muda '
                  '(bawah).',
              'Ketuk sebuah zaman untuk membuka ilustrasi, cara hidup, alat, '
                  'manusia, dan situs pentingnya.',
              'Tombol di bawah tiap zaman membuka artefak zaman itu.',
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Text(
            'Perjalanan manusia di tanah Jawa dari masa ke masa. Ketuk '
            'sebuah zaman untuk melihat detailnya.',
            style: AppText.body(context, size: 14, color: p.muted),
          ),
          const SizedBox(height: 16),
          // Batang ringkasan 5 zaman.
          Row(
            children: [
              for (var i = 0; i < list.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _open = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: i == _open ? 14 : 8,
                        decoration: BoxDecoration(
                          color: i == _open
                              ? list[i].color
                              : list[i].color.op(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tertua', style: AppText.muted(context, size: 11)),
              Text('Termuda', style: AppText.muted(context, size: 11)),
            ],
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < list.length; i++)
            _TimelineItem(
              category: list[i],
              count: categories.countOf(list[i].name),
              isFirst: i == 0,
              isLast: i == list.length - 1,
              expanded: _open == i,
              onToggle: () => setState(() => _open = _open == i ? -1 : i),
              onOpenArtifacts: () => _openEra(list[i].name),
            ),
          const SizedBox(height: 10),
          SoftCard(
            color: p.soft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 19, color: p.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Rentang waktu bersifat perkiraan dan dapat saling '
                    'tumpang tindih, karena perubahan budaya tidak terjadi '
                    'serentak di semua tempat.',
                    style: AppText.body(context, size: 12.5, height: 1.55),
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

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.category,
    required this.count,
    required this.isFirst,
    required this.isLast,
    required this.expanded,
    required this.onToggle,
    required this.onOpenArtifacts,
  });

  final PrehistoricCategory category;
  final int count;
  final bool isFirst;
  final bool isLast;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onOpenArtifacts;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final color = category.color;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 38,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 14,
                  color: isFirst ? Colors.transparent : p.border,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: expanded ? color : p.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(category.icon,
                      size: 16, color: expanded ? Colors.white : color),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : p.border,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: expanded ? color.op(0.6) : p.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onToggle,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(category.name,
                                      style: AppText.display(context,
                                          size: 17, color: color)),
                                  const SizedBox(height: 2),
                                  Text(category.range,
                                      style: AppText.muted(context,
                                          size: 11.5,
                                          weight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(category.highlight,
                                      style: AppText.body(context,
                                          size: 12.5, height: 1.4)),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: p.muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: expanded
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 0, 14, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SizedBox(
                                      height: 128,
                                      width: double.infinity,
                                      child: ArtImage(
                                          path: AppAssets.eraScene(category.name)),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(category.description,
                                      style: AppText.body(context,
                                          size: 13.5, height: 1.6)),
                                  const SizedBox(height: 12),
                                  _Detail(
                                      icon: Icons.home_work_outlined,
                                      label: 'Cara hidup',
                                      value: category.lifestyle,
                                      color: color),
                                  _Detail(
                                      icon: Icons.handyman_outlined,
                                      label: 'Alat & benda',
                                      value: category.tools,
                                      color: color),
                                  _Detail(
                                      icon: Icons.groups_2_outlined,
                                      label: 'Manusia',
                                      value: category.humans,
                                      color: color),
                                  _Detail(
                                      icon: Icons.place_outlined,
                                      label: 'Situs penting',
                                      value: category.sites,
                                      color: color),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: onOpenArtifacts,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: color,
                                          foregroundColor: Colors.white),
                                      child: Text('Lihat $count artefak'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppText.muted(context,
                        size: 11, weight: FontWeight.w700)),
                Text(value,
                    style: AppText.body(context, size: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
