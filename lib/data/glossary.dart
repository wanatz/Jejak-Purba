/// Satu istilah di glosarium prasejarah.
class GlossaryTerm {
  const GlossaryTerm(this.term, this.category, this.definition);

  final String term;
  final String category;
  final String definition;
}

/// Istilah penting prasejarah, diurutkan abjad.
const List<GlossaryTerm> kGlossary = [
  GlossaryTerm('Abris sous roche', 'Hunian',
      'Ceruk di bawah tebing batu yang dipakai manusia purba sebagai tempat '
      'berlindung dan tinggal.'),
  GlossaryTerm('Arca megalitik', 'Megalitik',
      'Patung batu sederhana berwujud manusia atau hewan yang dipuja '
      'sebagai perwujudan leluhur.'),
  GlossaryTerm('Artefak', 'Arkeologi',
      'Benda buatan atau hasil olahan manusia, misalnya kapak batu, '
      'gerabah, dan perhiasan.'),
  GlossaryTerm('Austronesia', 'Budaya',
      'Rumpun bangsa penutur bahasa Austronesia yang menyebar dari Taiwan '
      'ke Asia Tenggara dan Pasifik, membawa pertanian dan gerabah.'),
  GlossaryTerm('Beliung', 'Alat',
      'Kapak batu yang diasah halus dan dipasang melintang pada tangkai, '
      'lazim pada masa Neolitikum.'),
  GlossaryTerm('Bekal kubur', 'Kepercayaan',
      'Benda yang disertakan bersama jenazah, seperti gerabah dan '
      'manik-manik, untuk bekal di alam setelah mati.'),
  GlossaryTerm('Bercocok tanam', 'Budaya',
      'Cara hidup bertani yang mulai berkembang pada Neolitikum dan '
      'membuat manusia menetap.'),
  GlossaryTerm('Cagar budaya', 'Pelestarian',
      'Warisan budaya bernilai penting yang dilindungi undang-undang, '
      'misalnya situs, bangunan, dan benda.'),
  GlossaryTerm('Cetakan setangkup', 'Logam',
      'Cetakan dua belahan (bivalve) dari batu atau tanah liat untuk '
      'mencetak benda perunggu.'),
  GlossaryTerm('Dolmen', 'Megalitik',
      'Meja batu: lempeng batu besar di atas batu penyangga yang dipakai '
      'sebagai altar atau penutup kubur.'),
  GlossaryTerm('Dongson', 'Logam',
      'Budaya perunggu dari Vietnam utara yang pengaruhnya sampai ke '
      'Nusantara lewat perdagangan, terkenal dengan nekaranya.'),
  GlossaryTerm('Ekskavasi', 'Arkeologi',
      'Penggalian arkeologi yang dilakukan secara sistematis dan '
      'terdokumentasi untuk menemukan tinggalan masa lalu.'),
  GlossaryTerm('Fosil', 'Paleontologi',
      'Sisa makhluk hidup purba yang telah mengeras menjadi batu atau '
      'tersimpan dalam lapisan tanah.'),
  GlossaryTerm('Gerabah', 'Alat',
      'Peralatan dari tanah liat yang dibakar pada suhu rendah, misalnya '
      'periuk dan kendi.'),
  GlossaryTerm('Holosen', 'Geologi',
      'Zaman geologi setelah Zaman Es, sejak sekitar 11.700 tahun lalu '
      'hingga sekarang.'),
  GlossaryTerm('Homo erectus', 'Manusia Purba',
      'Manusia purba berjalan tegak yang hidup di Jawa sekitar ratusan '
      'ribu tahun lalu, dikenal sebagai Manusia Jawa.'),
  GlossaryTerm('Homo sapiens', 'Manusia Purba',
      'Spesies manusia modern. Bukti awalnya di Jawa antara lain fosil '
      'manusia Wajak.'),
  GlossaryTerm('Kapak perimbas', 'Alat',
      'Kapak batu kasar yang dipangkas pada satu sisi untuk membelah dan '
      'memotong, khas Kebudayaan Pacitanian.'),
  GlossaryTerm('Knapping', 'Teknik',
      'Teknik memangkas batu dengan pukulan untuk menghasilkan serpihan '
      'bertepi tajam.'),
  GlossaryTerm('Menhir', 'Megalitik',
      'Batu tegak yang didirikan sebagai tugu peringatan atau pemujaan '
      'arwah leluhur.'),
  GlossaryTerm('Mikrolit', 'Alat',
      'Serpihan batu berukuran sangat kecil berbentuk geometris, dipasang '
      'sebagai mata panah atau pisau majemuk.'),
  GlossaryTerm('Nekara', 'Logam',
      'Genderang perunggu berbentuk seperti dispenser yang dipakai dalam '
      'upacara dan sebagai penanda status.'),
  GlossaryTerm('Nomaden', 'Budaya',
      'Cara hidup berpindah-pindah mengikuti ketersediaan makanan, '
      'umum pada masa Palaeolitikum.'),
  GlossaryTerm('Oker', 'Bahan',
      'Tanah berpigmen merah atau kuning yang dihaluskan untuk pewarna, '
      'sering dipakai dalam upacara penguburan.'),
  GlossaryTerm('Patina', 'Logam',
      'Lapisan hijau atau kecoklatan pada logam tua akibat reaksi dengan '
      'udara dan tanah, misalnya karat hijau pada perunggu.'),
  GlossaryTerm('Pengecoran', 'Logam',
      'Teknik menuang logam cair ke cetakan hingga mengeras menjadi '
      'bentuk benda.'),
  GlossaryTerm('Pipisan', 'Alat',
      'Landasan batu untuk menggiling biji, umbi, atau pewarna bersama '
      'batu penggiling.'),
  GlossaryTerm('Pleistosen', 'Geologi',
      'Zaman geologi yang dikenal sebagai Zaman Es, sekitar 2,6 juta '
      'hingga 11.700 tahun lalu.'),
  GlossaryTerm('Sarkofagus', 'Megalitik',
      'Peti jenazah dari batu utuh, terdiri atas wadah dan tutup.'),
  GlossaryTerm('Lumpang batu', 'Megalitik',
      'Balok batu dengan cekungan besar di permukaannya, dipakai untuk '
      'menumbuk dan diduga juga untuk sesaji.'),
  GlossaryTerm('Serpih (flake)', 'Alat',
      'Pecahan tipis bertepi tajam yang terlepas saat batu inti dipukul, '
      'dipakai sebagai pisau.'),
  GlossaryTerm('Situs', 'Arkeologi',
      'Lokasi yang mengandung tinggalan masa lalu, seperti gua hunian, '
      'bengkel batu, atau pemakaman.'),
  GlossaryTerm('Stratigrafi', 'Arkeologi',
      'Studi lapisan tanah: lapisan bawah lebih tua daripada lapisan di '
      'atasnya sehingga dapat menunjukkan urutan waktu.'),
  GlossaryTerm('Tatap-pelandas', 'Teknik',
      'Teknik membuat gerabah dengan memukul tanah liat memakai pemukul '
      '(tatap) sambil ditahan batu atau landasan (pelandas).'),
];
