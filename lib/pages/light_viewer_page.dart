import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/artifact.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// "Periksa dengan Cahaya": geser jari untuk mengubah arah cahaya dan
/// melihat relief, bekas pangkasan, serta hiasan pada permukaan benda.
///
/// Arkeolog memakai prinsip yang sama (cahaya miring) untuk membaca
/// permukaan artefak yang nyaris tak terlihat pada cahaya biasa.
class LightViewerPage extends StatefulWidget {
  const LightViewerPage({Key? key, required this.artifact}) : super(key: key);

  final Artifact artifact;

  @override
  State<LightViewerPage> createState() => _LightViewerPageState();
}

class _LightViewerPageState extends State<LightViewerPage> {
  /// Sudut cahaya dalam radian (0 = kanan, searah jarum jam).
  double _angle = -math.pi * 0.75;
  bool _touched = false;
  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final path in widget.artifact.lightFrames) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _update(Offset local, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final d = local - c;
    if (d.distance < 6) return;
    setState(() {
      _angle = math.atan2(d.dy, d.dx);
      _touched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final frames = widget.artifact.lightFrames;
    final p = AppPalette.of(context);

    // Campur dua bingkai terdekat agar perpindahan cahaya mulus.
    var a = _angle;
    if (a < 0) a += math.pi * 2;
    final pos = a / (math.pi / 4);
    final i0 = pos.floor() % 8;
    final i1 = (i0 + 1) % 8;
    final t = pos - pos.floor();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0908),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Periksa dengan Cahaya',
                            style: AppText.display(context,
                                size: 18, color: Colors.white)),
                        Text(widget.artifact.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.op(0.65), fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Bantuan',
                    icon: const Icon(Icons.help_outline_rounded,
                        color: Colors.white),
                    onPressed: () => showHelpSheet(
                      context,
                      title: 'Cara memakai Cahaya Interaktif',
                      steps: const [
                        'Seret jari di atas gambar. Cahaya datang dari arah '
                            'jari berada.',
                        'Perhatikan bayangan di permukaan: cekungan dan '
                            'tonjolan yang tadinya samar jadi terlihat jelas.',
                        'Arkeolog memakai cahaya miring seperti ini untuk '
                            'membaca bekas pangkasan dan ukiran pada artefak.',
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, c) {
                    final w = c.maxWidth;
                    final h = math.min(c.maxHeight, w * 3 / 4);
                    final size = Size(h * 4 / 3 > w ? w : h * 4 / 3, h);
                    return GestureDetector(
                      onPanStart: (d) => _update(d.localPosition, size),
                      onPanUpdate: (d) => _update(d.localPosition, size),
                      onTapDown: (d) => _update(d.localPosition, size),
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(frames[i0],
                                fit: BoxFit.cover, gaplessPlayback: true),
                            Opacity(
                              opacity: t.clamp(0.0, 1.0).toDouble(),
                              child: Image.asset(frames[i1],
                                  fit: BoxFit.cover, gaplessPlayback: true),
                            ),
                            // Penunjuk arah cahaya.
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _SunPainter(angle: _angle),
                              ),
                            ),
                            if (!_touched)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: Colors.black.op(0.55),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.touch_app_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text('Seret jari untuk menggeser cahaya',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.5)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.light_mode_rounded,
                          color: p.primary.op(0.9), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Cahaya dari ${_directionLabel(_angle)}',
                        style: TextStyle(
                            color: Colors.white.op(0.85),
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bagian yang menonjol tampak terang pada sisi yang '
                    'menghadap cahaya, sedangkan cekungan membentuk bayangan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.op(0.6), fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _directionLabel(double angle) {
    var a = angle;
    if (a < 0) a += math.pi * 2;
    final idx = ((a / (math.pi / 4)).round()) % 8;
    const labels = [
      'kanan',
      'kanan bawah',
      'bawah',
      'kiri bawah',
      'kiri',
      'kiri atas',
      'atas',
      'kanan atas',
    ];
    return labels[idx];
  }
}

/// Lingkaran kecil bergambar matahari di tepi gambar sesuai arah cahaya.
class _SunPainter extends CustomPainter {
  const _SunPainter({required this.angle});

  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final rx = size.width / 2 - 26;
    final ry = size.height / 2 - 26;
    final at = Offset(c.dx + math.cos(angle) * rx, c.dy + math.sin(angle) * ry);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.op(0.16);
    canvas.drawOval(Rect.fromCenter(center: c, width: rx * 2, height: ry * 2), ring);

    canvas.drawCircle(
        at, 22, Paint()..color = const Color(0xFFFFD27A).op(0.28));
    canvas.drawCircle(at, 11, Paint()..color = const Color(0xFFFFE3A3));
    final ray = Paint()
      ..color = const Color(0xFFFFE3A3).op(0.9)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
        at + Offset(math.cos(a), math.sin(a)) * 15,
        at + Offset(math.cos(a), math.sin(a)) * 20,
        ray,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SunPainter old) => old.angle != angle;
}
