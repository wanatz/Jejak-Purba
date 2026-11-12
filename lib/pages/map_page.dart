import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../models/museum.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';
import '../widgets/museum_card.dart';
import 'detail_page.dart';
import 'museum_detail_page.dart';

/// Proyeksi sederhana koordinat Jawa Timur ke bidang gambar.
class _Geo {
  static const double minLon = 110.9;
  static const double maxLon = 114.5;
  static const double maxLat = -6.7;
  static const double minLat = -8.9;

  static double aspect = (maxLon - minLon) / (maxLat - minLat);

  static Offset project(double lat, double lon, Size size) {
    final x = (lon - minLon) / (maxLon - minLon) * size.width;
    final y = (maxLat - lat) / (maxLat - minLat) * size.height;
    return Offset(x, y);
  }

  /// Garis pantai Jawa Timur (perkiraan, gaya ilustrasi): (lat, lon).
  static const List<List<double>> mainland = [
    [-6.88, 111.60], [-6.90, 112.00], [-6.92, 112.30], [-7.12, 112.55],
    [-7.25, 112.78], [-7.62, 112.92], [-7.70, 113.30], [-7.72, 113.80],
    [-7.78, 114.10], [-8.05, 114.40], [-8.35, 114.43], [-8.72, 114.45],
    [-8.62, 114.20], [-8.40, 113.95], [-8.45, 113.50], [-8.38, 113.00],
    [-8.40, 112.50], [-8.35, 112.00], [-8.32, 111.50], [-8.30, 111.10],
    [-8.22, 110.95], [-7.95, 111.02], [-7.60, 111.05], [-7.30, 111.15],
    [-7.05, 111.30],
  ];

  static const List<List<double>> madura = [
    [-7.05, 112.72], [-6.95, 112.95], [-6.88, 113.30], [-6.90, 113.70],
    [-6.97, 114.10], [-7.10, 114.15], [-7.18, 113.80], [-7.20, 113.40],
    [-7.18, 113.00], [-7.12, 112.80],
  ];

  static const List<_City> cities = [
    _City('Surabaya', -7.25, 112.75),
    _City('Malang', -7.98, 112.63),
    _City('Madiun', -7.63, 111.52),
    _City('Kediri', -7.82, 112.02),
    _City('Jember', -8.17, 113.70),
    _City('Banyuwangi', -8.22, 114.37),
    _City('Pacitan', -8.20, 111.10),
  ];
}

class _City {
  const _City(this.name, this.lat, this.lon);
  final String name;
  final double lat;
  final double lon;
}

/// Peta stilasi Jawa Timur berisi museum dan situs temuan artefak.
/// Bisa di-zoom dan digeser; ketuk penanda untuk melihat isinya.
class MapPage extends StatefulWidget {
  const MapPage({Key? key, this.focusArtifactId}) : super(key: key);

  /// Bila diisi, peta langsung memperbesar lokasi temuan artefak ini.
  final int? focusArtifactId;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TransformationController _transform = TransformationController();
  bool _showMuseums = true;
  bool _showSites = true;
  String? _era;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      if (mounted) context.read<SettingsProvider>().markFlag('map');
    });
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _focusOn(Offset pin, Size size) {
    const scale = 2.6;
    final tx = size.width / 2 - pin.dx * scale;
    final ty = size.height / 2 - pin.dy * scale;
    _transform.value = Matrix4(
      scale, 0, 0, 0, //
      0, scale, 0, 0, //
      0, 0, 1, 0, //
      tx, ty, 0, 1,
    );
  }

  void _resetView() => _transform.value = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final artifacts = context.watch<ArtifactProvider>();
    final museums = context.watch<MuseumProvider>();
    final categories = context.watch<CategoryProvider>();

    final located = artifacts.locatedArtifacts
        .where((a) => _era == null || a.era == _era)
        .toList();

    // Kelompokkan artefak yang lokasinya berdekatan.
    final groups = <String, List<Artifact>>{};
    for (final a in located) {
      final key =
          '${a.latitude.toStringAsFixed(1)},${a.longitude.toStringAsFixed(1)}';
      groups.putIfAbsent(key, () => <Artifact>[]).add(a);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Situs'),
        actions: [
          const HelpButton(
            title: 'Cara memakai Peta Situs',
            steps: [
              'Cubit layar untuk memperbesar, seret untuk menggeser.',
              'Lingkaran bernomor = situs temuan; angkanya jumlah artefak '
                  'di sekitar lokasi itu.',
              'Ikon gedung = museum. Ketuk penanda untuk melihat isinya.',
              'Gunakan chip di atas peta untuk menampilkan atau menyaring '
                  'museum, situs, dan zaman.',
              'Lokasi bersifat perkiraan untuk belajar, bukan untuk navigasi.',
            ],
          ),
          IconButton(
            tooltip: 'Atur ulang tampilan',
            onPressed: _resetView,
            icon: const Icon(Icons.center_focus_strong_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              children: [
                _ToggleChip(
                  label: 'Museum',
                  icon: Icons.account_balance_rounded,
                  selected: _showMuseums,
                  onTap: () => setState(() => _showMuseums = !_showMuseums),
                ),
                _ToggleChip(
                  label: 'Situs temuan',
                  icon: Icons.place_rounded,
                  selected: _showSites,
                  onTap: () => setState(() => _showSites = !_showSites),
                ),
                const SizedBox(width: 6),
                for (final c in categories.categories)
                  _ToggleChip(
                    label: c.name,
                    color: c.color,
                    selected: _era == c.name,
                    onTap: () =>
                        setState(() => _era = _era == c.name ? null : c.name),
                  ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final mapW = c.maxWidth - 24;
                final mapH = mapW / _Geo.aspect;
                final size = Size(mapW, mapH);

                // Fokus awal ke artefak tertentu (sekali saja).
                if (!_focused && widget.focusArtifactId != null) {
                  final a = artifacts.findById(widget.focusArtifactId);
                  if (a != null && a.hasLocation) {
                    _focused = true;
                    final pin = _Geo.project(a.latitude, a.longitude, size);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) _focusOn(pin, size);
                    });
                  }
                }

                return Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: p.border),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: p.isDark
                          ? const [Color(0xFF1F2A2E), Color(0xFF2A3338)]
                          : const [Color(0xFFD7E6E4), Color(0xFFC3D8D8)],
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(
                    transformationController: _transform,
                    minScale: 1,
                    maxScale: 5,
                    boundaryMargin: const EdgeInsets.all(120),
                    child: Center(
                      child: SizedBox(
                        width: mapW,
                        height: mapH,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _MapPainter(dark: p.isDark),
                              ),
                            ),
                            if (_showMuseums)
                              for (final m in museums.museums)
                                if (m.hasCoordinates)
                                  _positioned(
                                    _Geo.project(m.latitude, m.longitude, size),
                                    _MuseumPin(
                                      onTap: () => _showMuseumSheet(m),
                                      label: m.city,
                                    ),
                                  ),
                            if (_showSites)
                              for (final e in groups.entries)
                                _positioned(
                                  _Geo.project(e.value.first.latitude,
                                      e.value.first.longitude, size),
                                  _SitePin(
                                    count: e.value.length,
                                    color: EraStyle.color(e.value.first.era),
                                    highlighted: widget.focusArtifactId != null &&
                                        e.value.any((a) =>
                                            a.id == widget.focusArtifactId),
                                    onTap: () => _showSiteSheet(e.value),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Icon(Icons.pinch_rounded, size: 16, color: p.muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Cubit untuk zoom, ketuk penanda untuk melihat isinya. '
                    'Peta bersifat ilustrasi; lokasi adalah perkiraan.',
                    style: AppText.muted(context, size: 11.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _positioned(Offset o, Widget child) {
    return Positioned(
      left: o.dx - 28,
      top: o.dy - 28,
      width: 56,
      height: 56,
      child: child,
    );
  }

  void _showSiteSheet(List<Artifact> items) {
    final p = AppPalette.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.bg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: items.length > 2 ? 0.62 : 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (ctx, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
            Text('Situs temuan', style: AppText.display(ctx, size: 20)),
            const SizedBox(height: 2),
            Text('${items.length} artefak ditemukan di sekitar sini',
                style: AppText.muted(ctx)),
            const SizedBox(height: 14),
            for (final a in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ArtifactCard(
                  artifact: a,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    openArtifactDetail(context, a);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMuseumSheet(Museum m) {
    final p = AppPalette.of(context);
    final count = context.read<MuseumProvider>().artifactCount(m.name);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: p.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              MuseumRowCard(
                museum: m,
                artifactCount: count,
                onTap: () {
                  Navigator.of(ctx).pop();
                  AppRoute.push(context, MuseumDetailPage(museumName: m.name));
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.my_location_rounded, size: 16, color: p.muted),
                  const SizedBox(width: 6),
                  Text(m.coordinateLabel, style: AppText.muted(ctx)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final c = color ?? p.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? c : p.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? c : p.border),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: selected ? Colors.white : c),
                const SizedBox(width: 5),
              ],
              Text(label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : p.text,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _MuseumPin extends StatelessWidget {
  const _MuseumPin({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF583521),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0x55000000), blurRadius: 6),
              ],
            ),
            child: const Icon(Icons.account_balance_rounded,
                size: 14, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.op(0.85),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3A2A1E))),
          ),
        ],
      ),
    );
  }
}

class _SitePin extends StatefulWidget {
  const _SitePin({
    required this.count,
    required this.color,
    required this.onTap,
    required this.highlighted,
  });

  final int count;
  final Color color;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  State<_SitePin> createState() => _SitePinState();
}

class _SitePinState extends State<_SitePin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final t = _pulse.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 18 + 30 * t,
                height: 18 + 30 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color
                      .op((widget.highlighted ? 0.45 : 0.28) * (1 - t)),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text('${widget.count}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({required this.dark});

  final bool dark;

  Path _path(List<List<double>> pts, Size size) {
    final points =
        pts.map((e) => _Geo.project(e[0], e[1], size)).toList(growable: false);
    final path = Path();
    final n = points.length;
    Offset mid(Offset a, Offset b) => Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final start = mid(points[n - 1], points[0]);
    path.moveTo(start.dx, start.dy);
    for (var i = 0; i < n; i++) {
      final next = points[(i + 1) % n];
      final m = mid(points[i], next);
      path.quadraticBezierTo(points[i].dx, points[i].dy, m.dx, m.dy);
    }
    path.close();
    return path;
  }

  void _label(Canvas canvas, String text, Offset at,
      {double size = 10, Color? color, FontStyle style = FontStyle.normal}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color ?? (dark ? const Color(0xFFB9A892) : const Color(0xFF6E5A48)),
          fontWeight: FontWeight.w600,
          fontStyle: style,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Kisi koordinat tipis.
    final grid = Paint()
      ..color = (dark ? Colors.white : Colors.black).op(0.05)
      ..strokeWidth = 1;
    for (var i = 1; i < 8; i++) {
      final x = size.width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final land = dark ? const Color(0xFF4A3B2E) : const Color(0xFFE9D9BC);
    final edge = dark ? const Color(0xFF7A6248) : const Color(0xFFB59A72);

    for (final pts in [_Geo.mainland, _Geo.madura]) {
      final path = _path(pts, size);
      canvas.drawShadow(path, Colors.black, 4, false);
      canvas.drawPath(path, Paint()..color = land);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = edge,
      );
    }

    // Pegunungan sederhana (segitiga kecil) sebagai hiasan.
    final mount = Paint()..color = edge.op(0.55);
    for (final m in const [
      [-7.95, 112.95], [-7.62, 112.58], [-7.95, 113.35], [-8.1, 113.9],
      [-7.45, 111.95], [-7.9, 111.5],
    ]) {
      final c = _Geo.project(m[0], m[1], size);
      final path = Path()
        ..moveTo(c.dx - 7, c.dy + 5)
        ..lineTo(c.dx, c.dy - 7)
        ..lineTo(c.dx + 7, c.dy + 5)
        ..close();
      canvas.drawPath(path, mount);
    }

    for (final c in _Geo.cities) {
      final at = _Geo.project(c.lat, c.lon, size);
      canvas.drawCircle(at, 2.4, Paint()..color = edge);
      _label(canvas, c.name, at + const Offset(0, 11), size: 9);
    }

    _label(canvas, 'LAUT JAWA', Offset(size.width * 0.38, size.height * 0.07),
        size: 12, style: FontStyle.italic);
    _label(canvas, 'SAMUDRA HINDIA',
        Offset(size.width * 0.3, size.height * 0.94),
        size: 12, style: FontStyle.italic);
    _label(canvas, 'Madura', _Geo.project(-7.0, 113.4, size) + const Offset(0, -16),
        size: 9.5);
    _label(canvas, 'Selat Bali', _Geo.project(-8.2, 114.46, size) - const Offset(8, -24),
        size: 8.5, style: FontStyle.italic);

    // Mawar angin kecil.
    final rose = Offset(size.width * 0.93, size.height * 0.12);
    final rp = Paint()..color = edge;
    canvas.drawCircle(rose, 16, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = edge);
    final arrow = Path()
      ..moveTo(rose.dx, rose.dy - 14)
      ..lineTo(rose.dx - 5, rose.dy + 4)
      ..lineTo(rose.dx, rose.dy)
      ..lineTo(rose.dx + 5, rose.dy + 4)
      ..close();
    canvas.drawPath(arrow, rp);
    _label(canvas, 'U', rose + const Offset(0, -24), size: 9);

    // Garis skala.
    final sc = Offset(size.width * 0.06, size.height * 0.95);
    final scalePx = size.width / ((_Geo.maxLon - _Geo.minLon) * 111) * 50;
    canvas.drawLine(sc, sc + Offset(scalePx, 0), rp..strokeWidth = 2);
    canvas.drawLine(sc + const Offset(0, -4), sc + const Offset(0, 4), rp);
    canvas.drawLine(
        sc + Offset(scalePx, -4), sc + Offset(scalePx, 4), rp);
    _label(canvas, '50 km', sc + Offset(scalePx / 2, -10), size: 8.5);
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.dark != dark;
}
