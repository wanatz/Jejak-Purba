import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/glossary.dart';
import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../services/narration_service.dart';
import '../services/photo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import 'compare_page.dart';
import 'light_viewer_page.dart';
import 'map_page.dart';
import 'museum_detail_page.dart';

/// Membuka halaman detail artefak dengan transisi standar aplikasi.
void openArtifactDetail(BuildContext context, Artifact artifact) {
  if (artifact.id == null) return;
  AppRoute.push(context, DetailPage(artifactId: artifact.id!));
}

/// Detail satu artefak: foto, ringkasan cepat, deskripsi, posisi di
/// linimasa, bagian-bagian yang bisa dibuka (ciri khas, fungsi, penemuan,
/// fakta menarik), dan artefak terkait.
class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.artifactId}) : super(key: key);

  final int artifactId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    // Catat sebagai "pernah dilihat" setelah frame pertama.
    Future<void>.microtask(() {
      if (mounted) {
        context.read<ArtifactProvider>().markViewed(widget.artifactId);
      }
    });
  }

  @override
  void dispose() {
    NarrationService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artifactId = widget.artifactId;
    final p = AppPalette.of(context);
    final provider = context.watch<ArtifactProvider>();
    final artifact = provider.findById(artifactId);

    if (artifact == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Artefak tidak ditemukan',
          subtitle: 'Data ini mungkin sudah dihapus.',
        ),
      );
    }

    final category =
        context.watch<CategoryProvider>().categoryByName(artifact.era);
    final museums = context.watch<MuseumProvider>();
    final museum = museums.findByName(artifact.museum);
    final related = provider.related(artifact);
    final color = EraStyle.color(artifact.era);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Header(artifact: artifact),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(artifact.name,
                    style: AppText.display(context, size: 27, height: 1.15)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    EraBadge(era: artifact.era),
                    _Pill(
                        icon: Icons.hourglass_bottom_rounded,
                        text: artifact.ageBadge),
                    if (artifact.isCustom)
                      const _Pill(
                          icon: Icons.person_outline_rounded,
                          text: 'Koleksi saya'),
                  ],
                ),
                const SizedBox(height: 16),
                SoftCard(
                  color: p.soft,
                  onTap: museum == null
                      ? null
                      : () => AppRoute.push(
                          context, MuseumDetailPage(museumName: museum.name)),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: p.primary.op(0.14),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(Icons.account_balance_rounded,
                            color: p.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dipamerkan di',
                                style: AppText.muted(context, size: 11.5)),
                            Text(artifact.museum,
                                style: AppText.body(context,
                                    size: 14.5, weight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      if (museum != null)
                        Icon(Icons.chevron_right_rounded, color: p.muted),
                    ],
                  ),
                ),
                if (artifact.summary.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SummaryCard(text: artifact.summary, color: color),
                ],
                const SizedBox(height: 22),
                Text('Ringkasan Cepat',
                    style: AppText.display(context, size: 18)),
                const SizedBox(height: 12),
                _QuickFacts(artifact: artifact),
                if (artifact.hasLightFrames) ...[
                  const SizedBox(height: 14),
                  _LightCard(artifact: artifact),
                ],
                const SizedBox(height: 24),
                Text('Deskripsi', style: AppText.display(context, size: 18)),
                const SizedBox(height: 8),
                Text(artifact.description,
                    style: AppText.body(context, size: 14.5, height: 1.65)),
                if (artifact.significance.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _Callout(
                    icon: Icons.stars_rounded,
                    title: 'Mengapa penting?',
                    text: artifact.significance,
                    color: color,
                  ),
                ],
                _GlossaryChips(artifact: artifact),
                const SizedBox(height: 24),
                _EraPosition(era: artifact.era, category: category),
                const SizedBox(height: 22),
                if (artifact.characteristicList.isNotEmpty)
                  _Accordion(
                    icon: Icons.fingerprint_rounded,
                    title: 'Ciri Khas',
                    color: color,
                    initiallyExpanded: true,
                    child: _Bullets(
                        items: artifact.characteristicList, color: color),
                  ),
                if (artifact.functionPast.trim().isNotEmpty)
                  _Accordion(
                    icon: Icons.history_rounded,
                    title: 'Fungsi pada Masa Lalu',
                    color: color,
                    child: _Paragraph(artifact.functionPast),
                  ),
                if (artifact.functionToday.trim().isNotEmpty)
                  _Accordion(
                    icon: Icons.museum_outlined,
                    title: 'Makna Masa Kini',
                    color: color,
                    child: _Paragraph(artifact.functionToday),
                  ),
                if (artifact.discoveryInfo.trim().isNotEmpty)
                  _Accordion(
                    icon: Icons.travel_explore_rounded,
                    title: 'Kisah Penemuan',
                    color: color,
                    child: _Paragraph(artifact.discoveryInfo),
                  ),
                if (artifact.funFactList.isNotEmpty)
                  _Accordion(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Fakta Menarik',
                    color: color,
                    child:
                        _Bullets(items: artifact.funFactList, color: color),
                  ),
                if (artifact.hasLocation) ...[
                  const SizedBox(height: 4),
                  _LocationCard(artifact: artifact),
                ],
                const SizedBox(height: 14),
                _NotesCard(artifact: artifact),
              ],
            ),
          ),
          if (related.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SectionHeader(
                title: 'Artefak Terkait',
                subtitle: 'Temukan benda lain dari koleksi',
              ),
            ),
            SizedBox(
              height: 214,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => ArtifactTile(
                  artifact: related[i],
                  onTap: () => openArtifactDetail(context, related[i]),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
      bottomNavigationBar: _BottomActions(artifact: artifact),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({required this.artifact});

  final Artifact artifact;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final PageController _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifact = widget.artifact;
    final provider = context.read<ArtifactProvider>();
    final top = MediaQuery.of(context).padding.top;
    final gallery = artifact.gallery;

    return SizedBox(
      height: 350,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pages,
            itemCount: gallery.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => AppRoute.push(
                  context,
                  _ImageViewer(
                    paths: gallery,
                    labels: [
                      for (var k = 0; k < gallery.length; k++)
                        artifact.galleryLabel(k)
                    ],
                    initial: i,
                  )),
              child: ArtImage(path: gallery[i]),
            ),
          ),
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0x66000000), Color(0x00000000)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: top + 8,
            child: RoundIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Kembali',
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            right: 16,
            top: top + 8,
            child: Row(
              children: [
                if (artifact.isCustom) ...[
                  RoundIconButton(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Hapus artefak',
                    onTap: () => _confirmDelete(context, artifact),
                  ),
                  const SizedBox(width: 10),
                ],
                ValueListenableBuilder<bool>(
                  valueListenable: NarrationService.instance.speaking,
                  builder: (context, on, _) => RoundIconButton(
                    icon: on ? Icons.stop_rounded : Icons.volume_up_rounded,
                    tooltip: on ? 'Hentikan suara' : 'Dengarkan penjelasan',
                    active: false,
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      if (on) {
                        await NarrationService.instance.stop();
                        return;
                      }
                      final ok = await NarrationService.instance
                          .speak(_narrationText(artifact));
                      if (!ok) {
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              content: Text(
                                  'Suara tidak tersedia di perangkat ini')));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                RoundIconButton(
                  icon: Icons.add_a_photo_rounded,
                  tooltip: 'Tambah foto asli',
                  onTap: () => _showPhotoSheet(context, artifact.id!),
                ),
                const SizedBox(width: 10),
                RoundIconButton(
                  icon: artifact.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  active: artifact.isFavorite,
                  tooltip: artifact.isFavorite
                      ? 'Hapus dari favorit'
                      : 'Tambah ke favorit',
                  onTap: () => provider.toggleFavorite(artifact),
                ),
              ],
            ),
          ),
          if (gallery.length > 1)
            Positioned(
              left: 16,
              bottom: 44,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.op(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${artifact.galleryLabel(_page)}  ${_page + 1}/${gallery.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          if (gallery.length > 1)
            Positioned(
              right: 16,
              bottom: 50,
              child: Row(
                children: [
                  for (var i = 0; i < gallery.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.only(left: 5),
                      width: i == _page ? 20 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? Colors.white
                            : Colors.white.op(0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
            ),
          // Sudut atas membulat yang "menimpa" foto.
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: p.bg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Artifact artifact) async {
    final navigator = Navigator.of(context);
    final provider = context.read<ArtifactProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus artefak?'),
        content: Text('"${artifact.name}" akan dihapus dari koleksimu.'),
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
    if (ok == true) {
      await provider.deleteArtifact(artifact.id!);
      if (navigator.canPop()) navigator.pop();
    }
  }
}

/// Kartu lokasi temuan dengan tombol menuju peta.
class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      color: p.soft,
      onTap: () => AppRoute.push(
          context, MapPage(focusArtifactId: artifact.id)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: EraStyle.color(artifact.era).op(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.map_rounded,
                color: EraStyle.color(artifact.era), size: 23),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lihat di Peta',
                    style: AppText.display(context, size: 15.5)),
                const SizedBox(height: 2),
                Text(artifact.origin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.muted(context, size: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

/// Catatan pribadi pengguna untuk satu artefak.
class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.artifact});

  final Artifact artifact;

  Future<void> _edit(BuildContext context, String current) async {
    final provider = context.read<ArtifactProvider>();
    final p = AppPalette.of(context);
    final ctrl = TextEditingController(text: current);
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 18, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Catatan Saya', style: AppText.display(ctx, size: 19)),
            const SizedBox(height: 4),
            Text(artifact.name, style: AppText.muted(ctx)),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              autofocus: true,
              maxLines: 6,
              minLines: 4,
              decoration: appInputDecoration(ctx,
                  label: 'Tulis catatan',
                  hint: 'Kesan, pertanyaan, atau hal yang ingin diingat'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (current.isNotEmpty)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(''),
                      child: const Text('Hapus'),
                    ),
                  ),
                if (current.isNotEmpty) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(ctrl.text),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (result != null && artifact.id != null) {
      await provider.setNote(artifact.id!, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final note = context.watch<ArtifactProvider>().noteFor(artifact.id);
    return SoftCard(
      onTap: () => _edit(context, note),
      color: note.isEmpty ? p.card : const Color(0xFFB8862F).op(0.10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(note.isEmpty ? Icons.edit_note_rounded : Icons.sticky_note_2_rounded,
              color: const Color(0xFFB8862F), size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catatan Saya',
                    style: AppText.display(context, size: 15.5)),
                const SizedBox(height: 4),
                Text(
                  note.isEmpty
                      ? 'Ketuk untuk menulis catatan pribadi tentang artefak ini.'
                      : note,
                  style: note.isEmpty
                      ? AppText.muted(context, size: 12.5)
                      : AppText.body(context, size: 13.5, height: 1.5),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_rounded, size: 18, color: p.muted),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final provider = context.read<ArtifactProvider>();
    return Container(
      decoration: BoxDecoration(
        color: p.card,
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => provider.toggleFavorite(artifact),
                  icon: Icon(
                      artifact.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20),
                  label: Text(artifact.isFavorite
                      ? 'Hapus dari Favorit'
                      : 'Tambahkan ke Favorit'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => copyText(
                  context,
                  _summary(artifact),
                  'Ringkasan artefak disalin',
                ),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    minimumSize: const Size(52, 50)),
                child: const Icon(Icons.copy_rounded, size: 20),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => AppRoute.push(
                    context, ComparePage(initialId: artifact.id)),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    minimumSize: const Size(52, 50)),
                child: const Icon(Icons.compare_rounded, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _summary(Artifact a) {
    final b = StringBuffer()
      ..writeln(a.name)
      ..writeln('${a.era} · ${a.period}')
      ..writeln('Bahan: ${a.material}')
      ..writeln('Asal temuan: ${a.origin}')
      ..writeln('Museum: ${a.museum}')
      ..writeln()
      ..writeln(a.description);
    return b.toString().trim();
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: p.soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: p.muted),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: p.muted)),
        ],
      ),
    );
  }
}

class _QuickFacts extends StatelessWidget {
  const _QuickFacts({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final entries = <_FactEntry>[
      _FactEntry(Icons.hourglass_bottom_rounded, 'Usia', artifact.period),
      _FactEntry(Icons.diamond_outlined, 'Bahan', artifact.material),
      _FactEntry(Icons.straighten_rounded, 'Ukuran', artifact.dimensions),
      _FactEntry(Icons.groups_2_outlined, 'Budaya', artifact.culture),
      _FactEntry(Icons.place_outlined, 'Asal Temuan', artifact.origin),
      _FactEntry(Icons.event_outlined, 'Tahun Temuan', artifact.discoveryYear),
    ].where((e) => e.value.trim().isNotEmpty).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final e in entries) SizedBox(width: w, child: _FactTile(entry: e)),
          ],
        );
      },
    );
  }
}

class _FactEntry {
  const _FactEntry(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _FactTile extends StatelessWidget {
  const _FactTile({required this.entry});

  final _FactEntry entry;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      padding: const EdgeInsets.all(12),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(entry.icon, size: 15, color: p.primary),
              const SizedBox(width: 5),
              Text(entry.label,
                  style: AppText.muted(context,
                      size: 11.5, weight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          Text(entry.value,
              style: AppText.body(context,
                  size: 13, weight: FontWeight.w600, height: 1.35)),
        ],
      ),
    );
  }
}

/// Batang linimasa kecil: menunjukkan zaman artefak di antara 5 zaman.
class _EraPosition extends StatelessWidget {
  const _EraPosition({required this.era, required this.category});

  final String era;
  final PrehistoricCategory? category;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final all = CategoryProvider.allCategories;
    return SoftCard(
      color: p.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, size: 18, color: p.primary),
              const SizedBox(width: 8),
              Text('Posisi pada Linimasa',
                  style: AppText.display(context, size: 15.5)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final c in all)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: c.name == era ? 12 : 8,
                      decoration: BoxDecoration(
                        color: c.name == era
                            ? c.color
                            : c.color.op(0.28),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tertua', style: AppText.muted(context, size: 11)),
              Text('Termuda', style: AppText.muted(context, size: 11)),
            ],
          ),
          if (category != null) ...[
            const SizedBox(height: 10),
            Text(category!.name,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: category!.color,
                    fontSize: 13.5)),
            const SizedBox(height: 2),
            Text('${category!.range}. ${category!.highlight}.',
                style: AppText.body(context, size: 12.5, height: 1.45)),
          ],
        ],
      ),
    );
  }
}

/// Bagian yang bisa dibuka-tutup (seperti akordeon di wireframe).
class _Accordion extends StatelessWidget {
  const _Accordion({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
    this.initiallyExpanded = false,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: p.primary,
          collapsedIconColor: p.muted,
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.op(0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          title: Text(title,
              style: AppText.body(context, size: 14.5, weight: FontWeight.w700)),
          children: [child],
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppText.body(context, size: 14, height: 1.6));
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items, required this.color});

  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item,
                      style: AppText.body(context, size: 14, height: 1.5)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Penampil gambar layar penuh dengan geser antar foto dan zoom.
class _ImageViewer extends StatefulWidget {
  const _ImageViewer({
    required this.paths,
    required this.labels,
    this.initial = 0,
  });

  final List<String> paths;
  final List<String> labels;
  final int initial;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late final PageController _controller;
  late int _page;

  @override
  void initState() {
    super.initState();
    _page = widget.initial;
    _controller = PageController(initialPage: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.paths.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: ArtImage(path: widget.paths[i], fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: MediaQuery.of(context).padding.top + 8,
            child: RoundIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Tutup',
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          if (widget.paths.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.op(0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.labels[_page]}  ·  ${_page + 1}/${widget.paths.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Kotak "Intinya": satu kalimat agar pengunjung langsung paham.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: color.op(p.isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INTINYA',
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: color)),
          const SizedBox(height: 4),
          Text(text,
              style: AppText.body(context,
                  size: 14.5, weight: FontWeight.w600, height: 1.5)),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      color: p.soft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.display(context, size: 15)),
                const SizedBox(height: 4),
                Text(text,
                    style: AppText.body(context, size: 13.5, height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Istilah glosarium yang muncul pada artefak ini; ketuk untuk artinya.
class _GlossaryChips extends StatelessWidget {
  const _GlossaryChips({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final text = [
      artifact.name,
      artifact.description,
      artifact.characteristics,
      artifact.functionPast,
      artifact.material,
      artifact.culture,
    ].join(' ').toLowerCase();
    final matches = <GlossaryTerm>[];
    for (final t in kGlossary) {
      final key = t.term.split(' (').first.toLowerCase();
      if (text.contains(key)) matches.add(t);
      if (matches.length >= 6) break;
    }
    if (matches.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, size: 17, color: p.primary),
              const SizedBox(width: 6),
              Text('Istilah di halaman ini',
                  style: AppText.display(context, size: 15)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Ketuk istilah untuk melihat artinya.',
              style: AppText.muted(context, size: 11.5)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in matches)
                GestureDetector(
                  onTap: () => showHelpSheet(
                    context,
                    title: t.term,
                    steps: [t.definition],
                    numbered: false,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: p.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.primary.op(0.5)),
                    ),
                    child: Text(t.term,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: p.primary)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Lembar untuk menambah foto asli (kamera/galeri) atau menghapusnya.
void _showPhotoSheet(BuildContext context, int artifactId) {
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
      final artifact = provider.findById(artifactId);
      if (artifact == null) return const SizedBox.shrink();

      Future<void> add(ImageSource source) async {
        final path = await PhotoService.pick(source);
        if (path != null) await provider.addPhoto(artifact, path);
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
              Text('Foto Asli', style: AppText.display(ctx, size: 20)),
              const SizedBox(height: 4),
              Text(
                'Pasang foto museum atau fotomu sendiri. Foto tampil paling '
                'depan di galeri dan menjadi sampul artefak ini.',
                style: AppText.muted(ctx, size: 12.5),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => add(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_rounded, size: 20),
                      label: const Text('Kamera'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => add(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded, size: 20),
                      label: const Text('Galeri'),
                    ),
                  ),
                ],
              ),
              if (artifact.photos.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text('Foto saya (${artifact.photos.length})',
                    style: AppText.display(ctx, size: 15.5)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: artifact.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final path = artifact.photos[i];
                      return Stack(
                        children: [
                          ArtImage(
                              path: path, width: 96, height: 96, radius: 16),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () => provider.removePhoto(artifact, path),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD9534F),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded,
                                    color: Colors.white, size: 15),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

/// Teks yang dibacakan oleh fitur "Dengarkan penjelasan".
String _narrationText(Artifact a) {
  final b = StringBuffer()..write('${a.name}. ');
  if (a.summary.isNotEmpty) b.write('Intinya: ${a.summary} ');
  b.write('${a.description} ');
  if (a.significance.isNotEmpty) b.write('Mengapa penting? ${a.significance} ');
  if (a.functionPast.isNotEmpty) {
    b.write('Fungsi pada masa lalu: ${a.functionPast}');
  }
  return b.toString();
}

/// Kartu menuju "Periksa dengan Cahaya".
class _LightCard extends StatelessWidget {
  const _LightCard({required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final frames = artifact.lightFrames;
    return GestureDetector(
      onTap: () =>
          AppRoute.push(context, LightViewerPage(artifact: artifact)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14100D),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 92,
              child: ArtImage(path: frames[5]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.light_mode_rounded,
                          color: Color(0xFFFFD27A), size: 17),
                      const SizedBox(width: 6),
                      Text('Periksa dengan Cahaya',
                          style: AppText.display(context,
                              size: 14.5, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Geser arah cahaya untuk melihat relief dan bekas '
                    'pangkasan seperti arkeolog.',
                    style: TextStyle(
                        color: Colors.white.op(0.7),
                        fontSize: 12,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.chevron_right_rounded, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
