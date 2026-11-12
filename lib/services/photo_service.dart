import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Mengambil foto dari kamera/galeri lalu menyalinnya ke penyimpanan
/// aplikasi agar tetap tersedia walau file aslinya dihapus.
class PhotoService {
  PhotoService._();

  static final ImagePicker _picker = ImagePicker();

  /// Mengembalikan path berkas tersimpan, atau null bila dibatalkan/gagal.
  static Future<String?> pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        imageQuality: 88,
      );
      if (picked == null) return null;
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory(p.join(dir.path, 'photos'));
      if (!await folder.exists()) await folder.create(recursive: true);
      var ext = p.extension(picked.path);
      if (ext.isEmpty) ext = '.jpg';
      final name = 'p_${DateTime.now().microsecondsSinceEpoch}$ext';
      final saved = await File(picked.path).copy(p.join(folder.path, name));
      return saved.path;
    } catch (_) {
      return null;
    }
  }

  static Future<void> delete(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // Berkas sudah tidak ada: abaikan.
    }
  }
}
