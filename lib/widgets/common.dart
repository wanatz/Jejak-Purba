import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Transisi halaman: memudar sambil naik sedikit. Dipakai seluruh aplikasi.
class AppRoute {
  AppRoute._();

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Menyalin teks ke clipboard sambil menampilkan notifikasi singkat.
Future<void> copyText(BuildContext context, String text, String message) async {
  final messenger = ScaffoldMessenger.of(context);
  await Clipboard.setData(ClipboardData(text: text));
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Gambar aset dengan placeholder bila file tidak ditemukan.
class ArtImage extends StatelessWidget {
  const ArtImage({
    Key? key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius = 0,
  }) : super(key: key);

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    Widget fallback(BuildContext c, Object e, StackTrace? s) => Container(
          width: width,
          height: height,
          color: p.soft,
          child: Icon(Icons.image_outlined, color: p.muted),
        );
    // Path berkas (foto pengguna) diawali '/' atau huruf drive; sisanya aset.
    final isFile = path.startsWith('/') || path.startsWith('file:');
    final image = isFile
        ? Image.file(
            File(path.replaceFirst('file://', '')),
            fit: fit,
            width: width,
            height: height,
            errorBuilder: fallback,
          )
        : Image.asset(
            path,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: fallback,
          );
    if (radius <= 0) return image;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}

/// Kartu lembut dengan sudut membulat dan garis tepi tipis.
class SoftCard extends StatelessWidget {
  const SoftCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
    this.color,
    this.margin,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final shape = BorderRadius.circular(radius);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? p.card,
        borderRadius: shape,
        border: Border.all(color: p.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Judul bagian dengan tombol "Lihat Semua" opsional.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.seeAllLabel = 'Lihat Semua',
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.display(context, size: 19)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppText.muted(context)),
              ],
            ],
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Text(
                seeAllLabel,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.of(context).primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Lencana kecil berwarna sesuai zaman.
class EraBadge extends StatelessWidget {
  const EraBadge({Key? key, required this.era, this.solid = false})
      : super(key: key);

  final String era;

  /// true = latar penuh (di atas foto), false = latar transparan lembut.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final color = EraStyle.color(era);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: solid ? color : color.op(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(EraStyle.icon(era),
              size: 12, color: solid ? Colors.white : color),
          const SizedBox(width: 4),
          Text(
            era,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: solid ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol bulat di atas gambar (kembali, favorit, dll).
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.active = false,
    this.size = 40,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFD9534F)
              : Colors.black.op(0.38),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
    if (tooltip == null) return btn;
    return Tooltip(message: tooltip!, child: btn);
  }
}

/// Baris informasi kecil: ikon + teks.
class MetaLine extends StatelessWidget {
  const MetaLine({Key? key, required this.icon, required this.text})
      : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Row(
      children: [
        Icon(icon, size: 13, color: p.muted),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.muted(context, size: 12),
          ),
        ),
      ],
    );
  }
}

/// Motif lengkung konsentris halus untuk latar banner (nuansa lapisan tanah).
class StrataPatternPainter extends CustomPainter {
  const StrataPatternPainter({this.color = Colors.white, this.opacity = 0.08});

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.op(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final center = Offset(size.width * 0.88, size.height * 1.05);
    for (var i = 1; i <= 9; i++) {
      canvas.drawCircle(center, i * size.height * 0.22, paint);
    }
    final dot = Paint()..color = color.op(opacity * 1.6);
    final rnd = math.Random(4);
    for (var i = 0; i < 26; i++) {
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        rnd.nextDouble() * 1.8 + 0.6,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StrataPatternPainter old) =>
      old.color != color || old.opacity != opacity;
}

/// Tampilan standar untuk daftar kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: p.soft,
                shape: BoxShape.circle,
                border: Border.all(color: p.border),
              ),
              child: Icon(icon, size: 40, color: p.primary),
            ),
            const SizedBox(height: 18),
            Text(title,
                textAlign: TextAlign.center,
                style: AppText.display(context, size: 18)),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style: AppText.muted(context, size: 13.5)),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tab berbentuk pil dengan indikator geser.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    Key? key,
    required this.controller,
    required this.labels,
    required this.icons,
  }) : super(key: key);

  final TabController controller;
  final List<String> labels;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return AnimatedBuilder(
      animation: controller.animation!,
      builder: (context, _) {
        final value = controller.animation!.value;
        return Container(
          height: 46,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: p.soft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth / labels.length;
              return Stack(
                children: [
                  Positioned(
                    left: value * w,
                    top: 0,
                    bottom: 0,
                    width: w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: p.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(labels.length, (i) {
                      final active = (value - i).abs() < 0.5;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.animateTo(i),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icons[i],
                                  size: 17,
                                  color: active ? p.onPrimary : p.muted),
                              const SizedBox(width: 6),
                              Text(
                                labels[i],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: active ? p.onPrimary : p.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}


/// Dekorasi kolom isian formulir yang seragam.
InputDecoration appInputDecoration(
  BuildContext context, {
  required String label,
  String? hint,
  Widget? prefix,
}) {
  final p = AppPalette.of(context);
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefix,
    alignLabelWithHint: true,
    filled: true,
    fillColor: p.card,
    labelStyle: TextStyle(color: p.muted),
    hintStyle: TextStyle(color: p.muted.op(0.7), fontSize: 13.5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border(p.border),
    enabledBorder: border(p.border),
    focusedBorder: border(p.primary, 1.6),
    errorBorder: border(const Color(0xFFD9534F)),
    focusedErrorBorder: border(const Color(0xFFD9534F), 1.6),
  );
}

/// Tombol bantuan "?" yang membuka lembar cara pemakaian suatu fitur.
class HelpButton extends StatelessWidget {
  const HelpButton({Key? key, required this.title, required this.steps})
      : super(key: key);

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Bantuan',
      icon: const Icon(Icons.help_outline_rounded),
      onPressed: () => showHelpSheet(context, title: title, steps: steps),
    );
  }
}

/// Lembar bantuan: judul + langkah-langkah bernomor.
void showHelpSheet(
  BuildContext context, {
  required String title,
  required List<String> steps,
  bool numbered = true,
}) {
  final p = AppPalette.of(context);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: p.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (ctx) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.help_outline_rounded, color: p.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: AppText.display(ctx, size: 20)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (numbered) ...[
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: p.primary.op(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text('${i + 1}',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: p.primary)),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(steps[i],
                          style: AppText.body(ctx, size: 14, height: 1.5)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Memunculkan anak widget dengan memudar sambil naik sedikit.
/// Beri [delay] bertingkat pada daftar agar muncul berurutan.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 18,
  }) : super(key: key);

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );
  late final Animation<double> _curve =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _curve.value) * widget.offset),
          child: child,
        ),
      ),
    );
  }
}

/// Delay bertingkat untuk item daftar ke-[index] (maksimal 6 langkah).
Duration staggerDelay(int index, {int stepMs = 55}) =>
    Duration(milliseconds: stepMs * (index < 6 ? index : 6));
