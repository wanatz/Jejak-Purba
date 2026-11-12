/// Model satu museum di Jawa Timur yang menyimpan koleksi prasejarah.
///
/// Hanya berisi informasi pengenalan (alamat, jam buka, sejarah singkat,
/// koordinat). Aplikasi ini tidak menangani tiket maupun pencatatan
/// kunjungan.
class Museum {
  const Museum({
    this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.openHours,
    required this.description,
    required this.image,
    required this.established,
    this.phone = '',
    this.latitude = 0,
    this.longitude = 0,
    this.highlights = '',
  });

  final int? id;
  final String name;
  final String city;
  final String address;
  final String openHours;
  final String description;
  final String image;
  final String established;
  final String phone;
  final double latitude;
  final double longitude;

  /// Sorotan koleksi, satu butir per baris (dipisah `\n`).
  final String highlights;

  List<String> get highlightList => highlights
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);

  bool get hasCoordinates => latitude != 0 || longitude != 0;

  String get coordinateLabel =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';

  Museum copyWith({
    int? id,
    String? name,
    String? city,
    String? address,
    String? openHours,
    String? description,
    String? image,
    String? established,
    String? phone,
    double? latitude,
    double? longitude,
    String? highlights,
  }) {
    return Museum(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      openHours: openHours ?? this.openHours,
      description: description ?? this.description,
      image: image ?? this.image,
      established: established ?? this.established,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'open_hours': openHours,
      // Kolom lama dari versi database sebelumnya (NOT NULL). Tidak lagi
      // dipakai aplikasi, selalu diisi kosong agar insert tetap valid.
      'ticket_price': '',
      'description': description,
      'image': image,
      'established': established,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'highlights': highlights,
    };
  }

  static Museum fromMap(Map<String, Object?> map) {
    double toDouble(Object? value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    String s(String key) => (map[key] ?? '').toString();

    return Museum(
      id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}'),
      name: s('name'),
      city: s('city'),
      address: s('address'),
      openHours: s('open_hours'),
      description: s('description'),
      image: s('image'),
      established: s('established'),
      phone: s('phone'),
      latitude: toDouble(map['latitude']),
      longitude: toDouble(map['longitude']),
      highlights: s('highlights'),
    );
  }
}
