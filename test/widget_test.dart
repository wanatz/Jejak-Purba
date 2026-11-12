// Tes ringan: kerangka navigasi, kuis, model, dan seed data.
//
// DBHelper memakai plugin native (sqflite) yang tidak tersedia di host
// test, sehingga provider sengaja dibuat TANPA memanggil load().

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jatim_prehistoric_museum/models/artifact.dart';
import 'package:jatim_prehistoric_museum/models/museum.dart';
import 'package:jatim_prehistoric_museum/pages/main_shell_page.dart';
import 'package:jatim_prehistoric_museum/providers/artifact_provider.dart';
import 'package:jatim_prehistoric_museum/providers/category_provider.dart';
import 'package:jatim_prehistoric_museum/providers/museum_provider.dart';
import 'package:jatim_prehistoric_museum/providers/quiz_provider.dart';
import 'package:jatim_prehistoric_museum/providers/settings_provider.dart';
import 'package:jatim_prehistoric_museum/services/achievements.dart';
import 'package:jatim_prehistoric_museum/services/seed_data.dart';
import 'package:jatim_prehistoric_museum/theme/app_theme.dart';

void main() {
  group('Kerangka utama', () {
    testWidgets('menampilkan bilah navigasi dengan 5 tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ArtifactProvider>(
                create: (_) => ArtifactProvider()),
            ChangeNotifierProvider<CategoryProvider>(
                create: (_) => CategoryProvider()),
            ChangeNotifierProvider<MuseumProvider>(
                create: (_) => MuseumProvider()),
            ChangeNotifierProvider<QuizProvider>(create: (_) => QuizProvider()),
            ChangeNotifierProvider<SettingsProvider>(
                create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(theme: AppTheme.light, home: const MainShellPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(AppBottomNav), findsOneWidget);
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Jelajah'), findsWidgets);
      expect(find.text('Belajar'), findsWidgets);
      expect(find.text('Favorit'), findsWidgets);
      expect(find.text('Profil'), findsWidgets);
    });
  });

  group('QuizProvider', () {
    test('sesi berisi soal dan skor naik bila benar', () {
      final quiz = QuizProvider();
      expect(quiz.total, QuizProvider.sessionLength);
      quiz.answer(quiz.current!.correctIndex);
      expect(quiz.score, 1);
      expect(quiz.streak, 1);
      quiz.next();
      expect(quiz.index, 1);
    });

    test('jawaban salah dicatat untuk ditinjau', () {
      final quiz = QuizProvider();
      final q = quiz.current!;
      quiz.answer((q.correctIndex + 1) % q.options.length);
      expect(quiz.score, 0);
      expect(quiz.mistakes.length, 1);
    });
  });

  group('Model', () {
    test('Museum round-trip toMap/fromMap', () {
      const museum = Museum(
        name: 'Museum Trinil',
        city: 'Ngawi',
        address: 'Desa Kawu',
        openHours: '08.00 - 16.00',
        description: 'Museum situs',
        image: 'assets/images/museums/trinil.png',
        established: '1991',
        latitude: -7.3761,
        longitude: 111.4253,
      );
      final restored = Museum.fromMap(museum.toMap());
      expect(restored.name, museum.name);
      expect(restored.latitude, closeTo(museum.latitude, 0.0001));
    });

    test('Artifact round-trip dan daftar ciri', () {
      const a = Artifact(
        name: 'Uji',
        era: 'Neolitikum',
        museum: 'M',
        origin: 'O',
        material: 'B',
        period: 'P',
        thumbnail: 't',
        description: 'd',
        functionPast: 'f',
        characteristics: 'satu\ndua\n\ntiga',
        ageYears: 540000,
      );
      final r = Artifact.fromMap(a.toMap());
      expect(r.characteristicList, ['satu', 'dua', 'tiga']);
      expect(r.ageBadge, '540 rb tahun');
    });
  });

  group('SeedData', () {
    test('nama artefak unik dan zaman valid', () {
      final names = SeedData.artifacts.map((a) => a.name).toSet();
      expect(names.length, SeedData.artifacts.length);
      final eras = CategoryProvider.allCategories.map((c) => c.name).toSet();
      for (final a in SeedData.artifacts) {
        expect(eras.contains(a.era), isTrue, reason: a.name);
        expect(a.description.isNotEmpty, isTrue);
      }
    });

    test('semua museum artefak terdaftar', () {
      final museums = SeedData.museums.map((m) => m.name).toSet();
      for (final a in SeedData.artifacts) {
        expect(museums.contains(a.museum), isTrue, reason: a.name);
      }
    });
  });

  group('Fitur v2', () {
    test('galeri artefak berisi tiga foto', () {
      final a = SeedData.artifacts.first;
      expect(a.gallery.length, 3);
      expect(a.gallery[1].endsWith('_2.jpg'), isTrue);
    });

    test('foto pengguna menjadi sampul dan galeri terdepan', () {
      final a = SeedData.artifacts.first.copyWith(photos: ['/tmp/foto.jpg']);
      expect(a.cover, '/tmp/foto.jpg');
      expect(a.gallery.length, 4);
      expect(a.galleryLabel(0), 'Foto saya');
      expect(a.galleryLabel(1), 'Tampak utama');
    });

    test('setiap artefak punya ringkasan dan arti penting', () {
      for (final a in SeedData.artifacts) {
        expect(a.summary.isNotEmpty, isTrue, reason: a.name);
        expect(a.significance.isNotEmpty, isTrue, reason: a.name);
      }
    });

    test('bingkai cahaya tersedia untuk gambar bawaan', () {
      for (final a in SeedData.artifacts) {
        expect(a.hasLightFrames, isTrue, reason: a.name);
        expect(a.lightFrames.length, 8);
      }
    });

    test('kelompok bahan terdeteksi', () {
      for (final a in SeedData.artifacts) {
        expect(ArtifactProvider.materialGroups.contains(
            ArtifactProvider.materialGroup(a)), isTrue, reason: a.name);
      }
    });

    test('lencana tersedia dan awalnya terkunci', () {
      final list = Achievements.build(
        artifacts: ArtifactProvider(),
        museums: MuseumProvider(),
        settings: SettingsProvider(),
      );
      expect(list.length, greaterThanOrEqualTo(10));
      expect(list.every((a) => !a.unlocked), isTrue);
    });
  });
}
