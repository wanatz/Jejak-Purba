/// Tokoh peneliti prasejarah beserta kontribusinya.
class Scholar {
  const Scholar({
    required this.name,
    required this.years,
    required this.role,
    required this.origin,
    required this.summary,
    required this.contributions,
    required this.related,
  });

  final String name;
  final String years;
  final String role;
  final String origin;
  final String summary;
  final List<String> contributions;

  /// Nama artefak di aplikasi yang berhubungan dengan tokoh ini.
  final List<String> related;

  String get initials {
    final parts = name.split(' ').where((e) => e.isNotEmpty).toList();
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

const List<Scholar> kScholars = [
  Scholar(
    name: 'Eugene Dubois',
    years: '1858 - 1940',
    role: 'Ahli anatomi & paleoantropolog',
    origin: 'Belanda',
    summary:
        'Dokter militer Belanda yang sengaja mencari "mata rantai yang '
        'hilang" evolusi manusia di Hindia Belanda dan menemukannya di tepi '
        'Bengawan Solo.',
    contributions: [
        'Menemukan atap tengkorak Trinil (1891) dan tulang paha (1892)',
        'Menamai temuannya Pithecanthropus erectus, kini Homo erectus',
        'Mengkaji fosil manusia Wajak, Tulungagung',
    ],
    related: [
      'Fosil Tengkorak Pithecanthropus erectus',
      'Tulang Paha Trinil (Femur)',
      'Fosil Manusia Wajak',
    ],
  ),
  Scholar(
    name: 'G.H.R. von Koenigswald',
    years: '1902 - 1982',
    role: 'Paleontolog',
    origin: 'Jerman-Belanda',
    summary:
        'Peneliti fosil yang bekerja lama di Jawa dan berjasa mengenali '
        'banyak situs penting manusia purba dan alat batu.',
    contributions: [
        'Mengenali alat batu Kebudayaan Pacitanian (1935)',
        'Meneliti fosil manusia purba di Sangiran dan sekitarnya',
        'Memperkuat kerangka kronologi Pleistosen Jawa',
    ],
    related: ['Kapak Genggam Pacitan', 'Kapak Genggam Trinil'],
  ),
  Scholar(
    name: 'P.V. van Stein Callenfels',
    years: '1883 - 1938',
    role: 'Arkeolog',
    origin: 'Belanda',
    summary:
        'Arkeolog yang meneliti gua-gua hunian dan menetapkan dasar '
        'pengenalan budaya Mesolitikum di Nusantara.',
    contributions: [
        'Meneliti Gua Lawa, Sampung, Ponorogo (1928-1931)',
        'Mengenalkan Kebudayaan Sampung dengan alat tulangnya',
        'Mengkaji budaya pantai dan gua di Nusantara',
    ],
    related: ['Alat Tulang Sampung', 'Mikrolit Mata Panah'],
  ),
  Scholar(
    name: 'R.P. Soejono',
    years: '1926 - 2011',
    role: 'Arkeolog Indonesia',
    origin: 'Indonesia',
    summary:
        'Salah satu tokoh perintis arkeologi prasejarah Indonesia yang '
        'meneliti kubur dan tradisi megalitik serta menyusun buku sejarah '
        'nasional.',
    contributions: [
        'Meneliti situs kubur prasejarah, antara lain Gilimanuk (Bali)',
        'Penyunting jilid prasejarah Sejarah Nasional Indonesia',
        'Mengembangkan pendidikan arkeologi di Indonesia',
    ],
    related: ['Sarkofagus Batu', 'Menhir Bondowoso'],
  ),
  Scholar(
    name: 'Teuku Jacob',
    years: '1929 - 2007',
    role: 'Paleoantropolog Indonesia',
    origin: 'Indonesia',
    summary:
        'Antropolog fisik dari Universitas Gadjah Mada yang mengkaji '
        'fosil manusia purba Indonesia dan memperkenalkannya ke dunia '
        'ilmiah internasional.',
    contributions: [
        'Meneliti fosil manusia purba Jawa, termasuk Sangiran',
        'Menulis banyak karya tentang evolusi manusia di Indonesia',
        'Membina generasi paleoantropolog Indonesia',
    ],
    related: ['Fosil Tengkorak Pithecanthropus erectus'],
  ),
];
