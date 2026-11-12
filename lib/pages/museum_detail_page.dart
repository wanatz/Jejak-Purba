import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artifact_provider.dart';
import '../providers/museum_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import 'detail_page.dart';

/// Detail satu museum: foto, sejarah singkat, informasi (alamat, jam
/// buka, telepon, koordinat), sorotan, dan koleksi yang ada di aplikasi.
class MuseumDetailPage extends StatelessWidget {
  const MuseumDetailPage({Key? key, required this.museumName})
      : super(key: key);

  final String museumName;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final museums = context.watch<MuseumProvider>();
    final museum = museums.findByName(museumName);

    if (museum == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.account_balance_outlined,
          title: 'Museum tidak ditemukan',
        ),
      );
    }

    final collection = context.watch<ArtifactProvider>().byMuseum(museum.name);
    final fav = museums.isFavorite(museum.name);
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView(
                  children: [
                    ArtImage(path: museum.image),
                    ArtImage(
                        path: museum.image.replaceFirst('.jpg', '_2.jpg')),
                  ],
                ),
                const IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x66000000), Color(0x00000000)],
                        stops: [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 44,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.op(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swipe_rounded,
                            color: Colors.white, size: 14),
                        SizedBox(width: 5),
                        Text('Geser: tampak luar & ruang pamer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
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
                  child: RoundIconButton(
                    icon: fav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    active: fav,
                    tooltip: fav ? 'Hapus dari favorit' : 'Tambah ke favorit',
                    onTap: () => museums.toggleFavorite(museum.name),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -1,
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: p.bg,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(museum.name,
                    style: AppText.display(context, size: 27, height: 1.15)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(icon: Icons.place_rounded, text: museum.city),
                    _Chip(
                        icon: Icons.calendar_month_rounded,
                        text: 'Sejak ${museum.established}'),
                    _Chip(
                        icon: Icons.inventory_2_outlined,
                        text: '${collection.length} koleksi'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(museum.description,
                    style: AppText.body(context, size: 14.5, height: 1.65)),
                if (museum.highlightList.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text('Sorotan Koleksi',
                      style: AppText.display(context, size: 18)),
                  const SizedBox(height: 10),
                  for (final h in museum.highlightList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(Icons.star_rounded,
                                size: 17, color: p.primary),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(h,
                                style: AppText.body(context,
                                    size: 14, height: 1.45)),
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 22),
                Text('Informasi', style: AppText.display(context, size: 18)),
                const SizedBox(height: 12),
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.place_outlined,
                        label: 'Alamat',
                        value: museum.address,
                        onCopy: () => copyText(
                            context, museum.address, 'Alamat disalin'),
                      ),
                      _InfoRow(
                        icon: Icons.schedule_rounded,
                        label: 'Jam buka',
                        value: museum.openHours,
                      ),
                      if (museum.phone.isNotEmpty)
                        _InfoRow(
                          icon: Icons.call_outlined,
                          label: 'Telepon',
                          value: museum.phone,
                          onCopy: () => copyText(
                              context, museum.phone, 'Nomor disalin'),
                        ),
                      if (museum.hasCoordinates)
                        _InfoRow(
                          icon: Icons.my_location_rounded,
                          label: 'Koordinat',
                          value: museum.coordinateLabel,
                          onCopy: () => copyText(context,
                              museum.coordinateLabel, 'Koordinat disalin'),
                          isLast: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jam operasional dapat berubah. Periksa kembali langsung ke '
                  'museum sebelum berkunjung.',
                  style: AppText.muted(context, size: 11.5),
                ),
                const SizedBox(height: 26),
                Text('Koleksi di Aplikasi',
                    style: AppText.display(context, size: 18)),
                const SizedBox(height: 12),
                if (collection.isEmpty)
                  Text('Belum ada koleksi yang tercatat untuk museum ini.',
                      style: AppText.muted(context, size: 13.5))
                else
                  for (final a in collection)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ArtifactCard(
                        artifact: a,
                        onTap: () => openArtifactDetail(context, a),
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

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: p.soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: p.primary),
          const SizedBox(width: 5),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: p.text)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: p.border.op(0.7))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: p.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppText.muted(context,
                        size: 11.5, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(value,
                    style: AppText.body(context, size: 13.5, height: 1.4)),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              tooltip: 'Salin',
              onPressed: onCopy,
              icon: Icon(Icons.copy_rounded, size: 18, color: p.muted),
            ),
        ],
      ),
    );
  }
}
