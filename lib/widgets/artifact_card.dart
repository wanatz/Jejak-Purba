import 'package:flutter/material.dart';

import '../models/artifact.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Kartu baris: gambar di kiri, info di kanan (dipakai di daftar).
class ArtifactCard extends StatelessWidget {
  const ArtifactCard({
    Key? key,
    required this.artifact,
    required this.onTap,
    this.onToggleFavorite,
  }) : super(key: key);

  final Artifact artifact;
  final VoidCallback onTap;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ArtImage(path: artifact.cover, width: 86, height: 86, radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EraBadge(era: artifact.era),
                const SizedBox(height: 6),
                Text(
                  artifact.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display(context, size: 15.5, height: 1.2),
                ),
                const SizedBox(height: 5),
                MetaLine(icon: Icons.place_outlined, text: artifact.origin),
                const SizedBox(height: 2),
                MetaLine(
                    icon: Icons.hourglass_bottom_rounded,
                    text: artifact.ageBadge),
              ],
            ),
          ),
          if (onToggleFavorite != null)
            IconButton(
              tooltip: artifact.isFavorite
                  ? 'Hapus dari favorit'
                  : 'Tambah ke favorit',
              onPressed: onToggleFavorite,
              icon: Icon(
                artifact.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: artifact.isFavorite ? const Color(0xFFD9534F) : p.muted,
              ),
            )
          else
            Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

/// Kartu vertikal untuk carousel horizontal di beranda.
class ArtifactTile extends StatelessWidget {
  const ArtifactTile({
    Key? key,
    required this.artifact,
    required this.onTap,
    this.width = 164,
  }) : super(key: key);

  final Artifact artifact;
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
        radius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ArtImage(
                    path: artifact.cover, width: width, height: 118),
                Positioned(
                  left: 8,
                  top: 8,
                  child: EraBadge(era: artifact.era, solid: true),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artifact.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.display(context, size: 14, height: 1.2),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 12, color: p.muted),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          artifact.origin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.muted(context, size: 11.5),
                        ),
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

/// Kartu grid (2 kolom) untuk halaman Jelajah.
class ArtifactGridCard extends StatelessWidget {
  const ArtifactGridCard({
    Key? key,
    required this.artifact,
    required this.onTap,
    required this.onToggleFavorite,
  }) : super(key: key);

  final Artifact artifact;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SoftCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ArtImage(path: artifact.cover),
                Positioned(
                  left: 8,
                  top: 8,
                  child: EraBadge(era: artifact.era, solid: true),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: RoundIconButton(
                    icon: artifact.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    active: artifact.isFavorite,
                    size: 32,
                    onTap: onToggleFavorite,
                    tooltip: artifact.isFavorite
                        ? 'Hapus dari favorit'
                        : 'Tambah ke favorit',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artifact.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.display(context, size: 14, height: 1.2),
                ),
                const SizedBox(height: 5),
                Text(
                  artifact.ageBadge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: EraStyle.color(artifact.era),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  artifact.museum,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.muted(context, size: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
