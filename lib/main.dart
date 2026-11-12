import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/splash_page.dart';
import 'providers/artifact_provider.dart';
import 'providers/category_provider.dart';
import 'providers/museum_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JatimPrehistoricApp());
}

/// Root aplikasi: menyiapkan seluruh provider lalu menyerahkan alur
/// tampilan ke [SplashPage] (onboarding -> halaman utama).
class JatimPrehistoricApp extends StatelessWidget {
  const JatimPrehistoricApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()..load(),
        ),
        ChangeNotifierProvider<ArtifactProvider>(
          create: (_) => ArtifactProvider()..loadArtifacts(),
        ),
        ChangeNotifierProxyProvider<ArtifactProvider, CategoryProvider>(
          create: (_) => CategoryProvider(),
          update: (_, artifactProvider, previous) =>
              (previous ?? CategoryProvider())..update(artifactProvider),
        ),
        ChangeNotifierProxyProvider<ArtifactProvider, MuseumProvider>(
          create: (_) => MuseumProvider()..load(),
          update: (_, artifactProvider, previous) =>
              (previous ?? MuseumProvider())..update(artifactProvider),
        ),
        ChangeNotifierProvider<QuizProvider>(
          create: (_) => QuizProvider(),
        ),
      ],
      child: const _AppView(),
    );
  }
}

/// MaterialApp yang mendengarkan [SettingsProvider] agar perubahan tema
/// langsung diterapkan tanpa restart.
class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(settings.textScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const SplashPage(),
    );
  }
}
