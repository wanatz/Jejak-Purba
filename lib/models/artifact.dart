/// Model satu artefak/benda prasejarah.
///
/// Selain identitas dasar, model ini membawa detail kaya untuk halaman
/// detail: ciri khas, fungsi dulu & kini, fakta menarik, ukuran, budaya,
/// dan tahun temuan.
class Artifact {
  const Artifact({
    this.id,
    required this.name,
    required this.era,
    required this.museum,
    required this.origin,
    required this.material,
    required this.period,
    required this.thumbnail,
    required this.description,
    required this.functionPast,
    this.functionToday = '',
    this.discoveryInfo = '',
    this.dimensions = '',
    this.culture = '',
    this.discoveryYear = '',
    this.characteristics = '',
    this.funFacts = '',
    this.summary = '',
    this.significance = '',
    this.photos = const [],
    this.ageYears = 0,
    this.latitude = 0,
    this.longitude = 0,
    this.isFavorite = false,
    this.isCustom = false,
  });

  /// Primary key SQLite; null bila belum disimpan.
  final int? id;
  final String name;

  /// Palaeolitikum, Mesolitikum, Neolitikum, Megalitikum, atau Zaman Logam.
  final String era;
  final String museum;

  /// Lokasi temuan.
  final String origin;
  final String material;

  /// Rentang usia dalam teks, mis. "± 540.000 tahun lalu".
  final String period;

  /// Path aset gambar.
  final String thumbnail;
  final String description;
  final String functionPast;
  final String functionToday;
  final String discoveryInfo;

  /// Ukuran umum benda, mis. "± 12 - 18 cm".
  final String dimensions;

  /// Budaya/tradisi pembuat, mis. "Kebudayaan Pacitanian".
  final String culture;
  final String discoveryYear;

  /// Daftar ciri khas, satu butir per baris (dipisah `\n`).
  final String characteristics;

  /// Daftar fakta menarik, satu butir per baris (dipisah `\n`).
  final String funFacts;

  /// Ringkasan satu kalimat ("Intinya") agar pengunjung cepat paham.
  final String summary;

  /// Penjelasan mengapa artefak ini penting.
  final String significance;

  /// Foto milik pengguna (path berkas di perangkat), tidak disimpan di tabel.
  final List<String> photos;

  /// Perkiraan usia (tahun lalu) untuk pengurutan. 0 = tidak diketahui.
  final int ageYears;

  /// Koordinat perkiraan lokasi temuan (0 bila tidak diketahui).
  final double latitude;
  final double longitude;

  final bool isFavorite;
  final bool isCustom;

  bool get hasLocation => latitude != 0 || longitude != 0;

  /// Foto sampul: foto pengguna bila ada, kalau tidak ilustrasi bawaan.
  String get cover => photos.isNotEmpty ? photos.first : thumbnail;

  /// Tiga gambar bawaan: utama, detail permukaan, dan skala
  /// (`nama.jpg`, `nama_2.jpg`, `nama_3.jpg`).
  List<String> get bundledGallery {
    if (!thumbnail.endsWith('.jpg')) return [thumbnail];
    final base = thumbnail.substring(0, thumbnail.length - 4);
    return [thumbnail, '${base}_2.jpg', '${base}_3.jpg'];
  }

  /// Apakah tersedia 8 bingkai cahaya interaktif untuk artefak ini.
  bool get hasLightFrames =>
      thumbnail.startsWith('assets/images/artifacts/') &&
      thumbnail.endsWith('.jpg');

  /// 8 bingkai dengan arah cahaya berbeda (searah jarum jam dari kanan).
  List<String> get lightFrames {
    if (!hasLightFrames) return const [];
    final key = thumbnail.split('/').last.replaceAll('.jpg', '');
    return [for (var i = 0; i < 8; i++) 'assets/images/light/${key}_$i.jpg'];
  }

  /// Galeri lengkap: foto pengguna lebih dulu, lalu gambar bawaan.
  List<String> get gallery => [...photos, ...bundledGallery];

  static const List<String> galleryLabels = [
    'Tampak utama',
    'Detail permukaan',
    'Perbandingan skala',
  ];

  /// Label untuk foto ke-[index] di [gallery].
  String galleryLabel(int index) {
    if (index < photos.length) return 'Foto saya';
    final i = index - photos.length;
    return galleryLabels[i < galleryLabels.length ? i : galleryLabels.length - 1];
  }

  List<String> get characteristicList => _lines(characteristics);
  List<String> get funFactList => _lines(funFacts);

  static List<String> _lines(String raw) => raw
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);

  /// Usia ringkas untuk lencana, mis. "540 rb th".
  String get ageBadge {
    if (ageYears <= 0) return period;
    if (ageYears >= 1000000) {
      final v = ageYears / 1000000;
      return '${_trim(v)} jt tahun';
    }
    if (ageYears >= 1000) {
      return '${_trim(ageYears / 1000)} rb tahun';
    }
    return '$ageYears tahun';
  }

  static String _trim(double v) {
    final s = v.toStringAsFixed(v >= 10 ? 0 : 1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  String get uniqueKey => '$name|$museum';

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'era': era,
      'museum': museum,
      'origin': origin,
      'material': material,
      'period': period,
      'thumbnail': thumbnail,
      'description': description,
      'function_past': functionPast,
      'function_today': functionToday,
      'discovery_info': discoveryInfo,
      'dimensions': dimensions,
      'culture': culture,
      'discovery_year': discoveryYear,
      'characteristics': characteristics,
      'fun_facts': funFacts,
      'summary': summary,
      'significance': significance,
      'age_years': ageYears,
      'find_lat': latitude,
      'find_lng': longitude,
      'is_favorite': isFavorite ? 1 : 0,
      'is_custom': isCustom ? 1 : 0,
    };
  }

  factory Artifact.fromMap(Map<String, Object?> m) {
    String s(String key) => (m[key] as String?) ?? '';
    int n(String key) {
      final v = m[key];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse('${v ?? ''}') ?? 0;
    }

    double d(String key) {
      final v = m[key];
      if (v is num) return v.toDouble();
      return double.tryParse('${v ?? ''}') ?? 0;
    }

    return Artifact(
      id: m['id'] as int?,
      name: s('name'),
      era: s('era'),
      museum: s('museum'),
      origin: s('origin'),
      material: s('material'),
      period: s('period'),
      thumbnail: s('thumbnail'),
      description: s('description'),
      functionPast: s('function_past'),
      functionToday: s('function_today'),
      discoveryInfo: s('discovery_info'),
      dimensions: s('dimensions'),
      culture: s('culture'),
      discoveryYear: s('discovery_year'),
      characteristics: s('characteristics'),
      funFacts: s('fun_facts'),
      summary: s('summary'),
      significance: s('significance'),
      ageYears: n('age_years'),
      latitude: d('find_lat'),
      longitude: d('find_lng'),
      isFavorite: n('is_favorite') == 1,
      isCustom: n('is_custom') == 1,
    );
  }

  Artifact copyWith({
    int? id,
    String? name,
    String? era,
    String? museum,
    String? origin,
    String? material,
    String? period,
    String? thumbnail,
    String? description,
    String? functionPast,
    String? functionToday,
    String? discoveryInfo,
    String? dimensions,
    String? culture,
    String? discoveryYear,
    String? characteristics,
    String? funFacts,
    String? summary,
    String? significance,
    List<String>? photos,
    int? ageYears,
    double? latitude,
    double? longitude,
    bool? isFavorite,
    bool? isCustom,
  }) {
    return Artifact(
      id: id ?? this.id,
      name: name ?? this.name,
      era: era ?? this.era,
      museum: museum ?? this.museum,
      origin: origin ?? this.origin,
      material: material ?? this.material,
      period: period ?? this.period,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      functionPast: functionPast ?? this.functionPast,
      functionToday: functionToday ?? this.functionToday,
      discoveryInfo: discoveryInfo ?? this.discoveryInfo,
      dimensions: dimensions ?? this.dimensions,
      culture: culture ?? this.culture,
      discoveryYear: discoveryYear ?? this.discoveryYear,
      characteristics: characteristics ?? this.characteristics,
      funFacts: funFacts ?? this.funFacts,
      summary: summary ?? this.summary,
      significance: significance ?? this.significance,
      photos: photos ?? this.photos,
      ageYears: ageYears ?? this.ageYears,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  String toString() => 'Artifact(id: $id, name: $name, era: $era)';
}
