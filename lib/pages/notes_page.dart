import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'detail_page.dart';

/// Kumpulan catatan pribadi dari semua artefak.
class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArtifactProvider>();
    final items = provider.annotatedArtifacts;
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Saya')),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.edit_note_rounded,
              title: 'Belum ada catatan',
              subtitle:
                  'Buka detail artefak lalu ketuk kartu "Catatan Saya" untuk '
                  'menulis kesan atau pertanyaanmu.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = items[i];
                return SoftCard(
                  onTap: () => openArtifactDetail(context, a),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArtImage(
                          path: a.cover, width: 64, height: 64, radius: 14),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.display(context, size: 15)),
                            const SizedBox(height: 4),
                            Text(provider.noteFor(a.id),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.body(context,
                                    size: 13, height: 1.45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
