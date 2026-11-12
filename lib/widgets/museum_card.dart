import 'package:flutter/material.dart';

import '../models/museum.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Kartu museum untuk carousel horizontal.
class MuseumCard extends StatelessWidget {
  const MuseumCard({
    Key? key,
    required this.museum,
    required this.artifactCount,
    required this.onTap,
    this.width = 250,
  }) : super(key: key);

  final Museum museum;
  final int artifactCount;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SizedBox(
      width: width,
      child: SoftCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ArtImage(path: museum.image, width: width, height: 120),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.op(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.place_rounded,
                            size: 12, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(museum.city,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(museum.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.display(context, size: 15)),
                  const SizedBox(height: 4),
                  Text('$artifactCount koleksi di aplikasi',
                      style: AppText.muted(context, size: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 12, color: p.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(museum.openHours,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.muted(context, size: 11.5)),
                      ),
                    ],
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

/// Kartu baris museum untuk daftar di Jelajah dan Favorit.
class MuseumRowCard extends StatelessWidget {
  const MuseumRowCard({
    Key? key,
    required this.museum,
    required this.artifactCount,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  }) : super(key: key);

  final Museum museum;
  final int artifactCount;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ArtImage(path: museum.image, width: 86, height: 86, radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(museum.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.display(context, size: 15.5, height: 1.2)),
                const SizedBox(height: 5),
                MetaLine(icon: Icons.place_outlined, text: museum.city),
                const SizedBox(height: 2),
                MetaLine(
                    icon: Icons.inventory_2_outlined,
                    text: '$artifactCount koleksi · sejak ${museum.established}'),
              ],
            ),
          ),
          if (onToggleFavorite != null)
            IconButton(
              tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: onToggleFavorite,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? const Color(0xFFD9534F) : p.muted,
              ),
            )
          else
            Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}
