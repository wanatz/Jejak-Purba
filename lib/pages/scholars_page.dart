import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/scholars.dart';
import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'detail_page.dart';

/// Tokoh-tokoh peneliti prasejarah dan hubungannya dengan koleksi.
class ScholarsPage extends StatefulWidget {
  const ScholarsPage({Key? key}) : super(key: key);

  @override
  State<ScholarsPage> createState() => _ScholarsPageState();
}

class _ScholarsPageState extends State<ScholarsPage> {
  int _open = 0;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tokoh Peneliti')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text(
            'Orang-orang di balik temuan dan pengetahuan tentang prasejarah '
            'Nusantara.',
            style: AppText.body(context, size: 14, color: p.muted),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < kScholars.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ScholarCard(
                scholar: kScholars[i],
                open: _open == i,
                onTap: () => setState(() => _open = _open == i ? -1 : i),
                provider: provider,
              ),
            ),
        ],
      ),
    );
  }
}

class _ScholarCard extends StatelessWidget {
  const _ScholarCard({
    required this.scholar,
    required this.open,
    required this.onTap,
    required this.provider,
  });

  final Scholar scholar;
  final bool open;
  final VoidCallback onTap;
  final ArtifactProvider provider;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final List<Artifact> related = [];
    for (final n in scholar.related) {
      for (final a in provider.artifacts) {
        if (a.name == n) {
          related.add(a);
          break;
        }
      }
    }

    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [p.heroStart, p.heroEnd],
                      ),
                    ),
                    child: Text(scholar.initials,
                        style: AppText.display(context,
                            size: 19, color: Colors.white)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(scholar.name,
                            style: AppText.display(context, size: 16)),
                        const SizedBox(height: 2),
                        Text('${scholar.years} · ${scholar.origin}',
                            style: AppText.muted(context, size: 11.5)),
                        Text(scholar.role,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: p.primary)),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child:
                        Icon(Icons.keyboard_arrow_down_rounded, color: p.muted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(scholar.summary,
                            style:
                                AppText.body(context, size: 13.5, height: 1.6)),
                        const SizedBox(height: 12),
                        Text('Sumbangan penting',
                            style: AppText.display(context, size: 14.5)),
                        const SizedBox(height: 8),
                        for (final c in scholar.contributions)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(Icons.check_circle_rounded,
                                      size: 15, color: p.primary),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(c,
                                      style: AppText.body(context,
                                          size: 13, height: 1.45)),
                                ),
                              ],
                            ),
                          ),
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Koleksi terkait',
                              style: AppText.display(context, size: 14.5)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final a in related)
                                GestureDetector(
                                  onTap: () => openArtifactDetail(context, a),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        4, 4, 12, 4),
                                    decoration: BoxDecoration(
                                      color: p.soft,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ArtImage(
                                            path: a.cover,
                                            width: 28,
                                            height: 28,
                                            radius: 14),
                                        const SizedBox(width: 8),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 190),
                                          child: Text(a.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
