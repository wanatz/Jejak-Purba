import 'package:flutter/material.dart';

/// Opasitas tanpa API deprecated: `color.op(0.5)`.
extension ColorOp on Color {
  Color op(double opacity) =>
      withAlpha((opacity * 255).round().clamp(0, 255).toInt());
}

/// Lokasi aset gambar.
class AppAssets {
  AppAssets._();

  static const String hero = 'assets/images/hero.jpg';

  static String eraScene(String era) {
    switch (era) {
      case 'Palaeolitikum':
        return 'assets/images/eras/palaeo.jpg';
      case 'Mesolitikum':
        return 'assets/images/eras/meso.jpg';
      case 'Neolitikum':
        return 'assets/images/eras/neo.jpg';
      case 'Megalitikum':
        return 'assets/images/eras/mega.jpg';
      default:
        return 'assets/images/eras/logam.jpg';
    }
  }
}

/// Identitas aplikasi. Ganti di sini bila ingin mengubah nama/tagline.
class AppInfo {
  AppInfo._();

  static const String name = 'Jejak Purba';
  static const String subtitle = 'Prasejarah Jawa Timur';
  static const String tagline = 'Telusuri benda kuno peninggalan nenek moyang';
  static const String version = '2.3.0';
}

/// Palet warna bergaya wireframe: krem hangat + coklat tanah.
///
/// Dipakai lewat `AppPalette.of(context)` agar otomatis mengikuti mode
/// terang/gelap.
class AppPalette {
  const AppPalette({
    required this.isDark,
    required this.bg,
    required this.card,
    required this.soft,
    required this.border,
    required this.text,
    required this.muted,
    required this.primary,
    required this.onPrimary,
    required this.heroStart,
    required this.heroEnd,
  });

  final bool isDark;
  final Color bg;
  final Color card;
  final Color soft;
  final Color border;
  final Color text;
  final Color muted;
  final Color primary;
  final Color onPrimary;
  final Color heroStart;
  final Color heroEnd;

  static const AppPalette light = AppPalette(
    isDark: false,
    bg: Color(0xFFFBF6EE),
    card: Color(0xFFFFFFFF),
    soft: Color(0xFFF3E9DB),
    border: Color(0xFFE7D9C4),
    text: Color(0xFF3A2A1E),
    muted: Color(0xFF8C7967),
    primary: Color(0xFF7B5133),
    onPrimary: Color(0xFFFFFFFF),
    heroStart: Color(0xFF8E6140),
    heroEnd: Color(0xFF583521),
  );

  static const AppPalette dark = AppPalette(
    isDark: true,
    bg: Color(0xFF1A1410),
    card: Color(0xFF251D17),
    soft: Color(0xFF2F251D),
    border: Color(0xFF3E3228),
    text: Color(0xFFF3E9DA),
    muted: Color(0xFFB9A892),
    primary: Color(0xFFDCA66B),
    onPrimary: Color(0xFF2A1B10),
    heroStart: Color(0xFF6E4A30),
    heroEnd: Color(0xFF3B2416),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Gaya teks. Judul memakai font serif sistem supaya terasa "museum".
class AppText {
  AppText._();

  static const List<String> _serifFallback = <String>[
    'Noto Serif',
    'Georgia',
    'Times New Roman',
    'serif',
  ];

  static TextStyle display(
    BuildContext context, {
    double size = 24,
    FontWeight weight = FontWeight.w700,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'serif',
      fontFamilyFallback: _serifFallback,
      fontSize: size,
      fontWeight: weight,
      height: height ?? 1.2,
      letterSpacing: letterSpacing,
      color: color ?? AppPalette.of(context).text,
    );
  }

  static TextStyle body(
    BuildContext context, {
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height ?? 1.45,
      color: color ?? AppPalette.of(context).text,
    );
  }

  static TextStyle muted(BuildContext context,
      {double size = 12.5, FontWeight weight = FontWeight.w400}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: 1.35,
      color: AppPalette.of(context).muted,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7B5133),
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondary: p.primary,
      surface: p.card,
      onSurface: p.text,
      outline: p.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      canvasColor: p.bg,
      dividerColor: p.border,
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'serif',
          fontFamilyFallback: const <String>['Noto Serif', 'Georgia', 'serif'],
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: p.text,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          side: BorderSide(color: p.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.primary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.isDark ? const Color(0xFFF3E9DA) : p.text,
        contentTextStyle: TextStyle(
          color: p.isDark ? const Color(0xFF2A1B10) : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.primary),
    );
  }
}

/// Warna & ikon tiap zaman prasejarah. Satu sumber kebenaran agar
/// kartu, chip, dan timeline selalu seragam.
class EraStyle {
  EraStyle._();

  static Color color(String era) {
    switch (era) {
      case 'Palaeolitikum':
        return const Color(0xFF8A5A3B);
      case 'Mesolitikum':
        return const Color(0xFF6B8A45);
      case 'Neolitikum':
        return const Color(0xFF3F8A78);
      case 'Megalitikum':
        return const Color(0xFFA4513A);
      case 'Zaman Logam':
        return const Color(0xFFB8862F);
      default:
        return const Color(0xFF7B5133);
    }
  }

  static IconData icon(String era) {
    switch (era) {
      case 'Palaeolitikum':
        return Icons.hardware_rounded;
      case 'Mesolitikum':
        return Icons.terrain_rounded;
      case 'Neolitikum':
        return Icons.agriculture_rounded;
      case 'Megalitikum':
        return Icons.account_balance_rounded;
      case 'Zaman Logam':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.history_edu_rounded;
    }
  }
}
