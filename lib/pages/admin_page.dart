import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import 'add_artifact_page.dart';
import 'detail_page.dart';

/// "Koleksi Saya": daftar artefak buatan pengguna + tombol tambah.
class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();
    final mine = provider.customArtifacts;

    return Scaffold(
      appBar: AppBar(title: const Text('Koleksi Saya')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRoute.push(context, const AddArtifactPage()),
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Artefak'),
      ),
      body: mine.isEmpty
          ? EmptyState(
              icon: Icons.add_photo_alternate_outlined,
              title: 'Belum ada koleksi buatanmu',
              subtitle:
                  'Catat benda kuno yang kamu temui di museum atau situs, '
                  'lengkap dengan zaman, bahan, dan ceritanya.',
              actionLabel: 'Tambah Artefak',
              onAction: () => AppRoute.push(context, const AddArtifactPage()),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              itemCount: mine.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = mine[i];
                return Dismissible(
                  key: ValueKey<int?>(a.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9534F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus artefak?'),
                        content: Text('"${a.name}" akan dihapus.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Batal')),
                          ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Hapus')),
                        ],
                      ),
                    );
                    return ok == true;
                  },
                  onDismissed: (_) => provider.deleteArtifact(a.id!),
                  child: ArtifactCard(
                    artifact: a,
                    onTap: () => openArtifactDetail(context, a),
                  ),
                );
              },
            ),
    );
  }
}
