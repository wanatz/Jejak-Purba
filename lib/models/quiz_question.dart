/// Satu soal kuis pilihan ganda tentang prasejarah Jawa Timur.
///
/// [options] selalu 4 pilihan; [correctIndex] adalah indeks jawaban benar
/// (0-3). [explanation] tampil setelah menjawab agar kuis juga menjadi
/// media belajar.
class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.era = '',
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  /// Zaman yang relevan dengan soal (boleh kosong).
  final String era;

  String get correctAnswer => options[correctIndex];
}

const List<QuizQuestion> kQuizQuestions = [
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Siapa yang mengenali alat batu Kebudayaan Pacitanian pada 1935?',
    options: [
      'Eugene Dubois',
      'G.H.R. von Koenigswald',
      'van Stein Callenfels',
      'Raffles',
    ],
    correctIndex: 1,
    explanation:
        'Von Koenigswald mengenali alat-alat batu di sekitar Punung, Pacitan, '
        'yang kemudian dikenal sebagai Kebudayaan Pacitanian.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Pada tahun berapa Eugene Dubois menemukan atap tengkorak di Trinil?',
    options: ['1871', '1891', '1911', '1931'],
    correctIndex: 1,
    explanation:
        'Atap tengkorak Trinil ditemukan pada 1891, disusul tulang paha '
        'pada 1892.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Situs Trinil, tempat Manusia Jawa ditemukan, berada di kabupaten...',
    options: ['Ngawi', 'Madiun', 'Blitar', 'Banyuwangi'],
    correctIndex: 0,
    explanation:
        'Trinil terletak di tepi Bengawan Solo, Kabupaten Ngawi. Di sana '
        'berdiri Museum Trinil.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Berapa kira-kira volume otak Homo erectus dari Trinil?',
    options: ['± 400 cm³', '± 700 cm³', '± 940 cm³', '± 1.500 cm³'],
    correctIndex: 2,
    explanation:
        'Volume otaknya sekitar 940 cm³, lebih kecil dari manusia modern '
        '(± 1.350 cm³) tetapi jauh lebih besar dari kera.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Apa yang dibuktikan oleh tulang paha (femur) Trinil?',
    options: [
      'Manusia purba sudah bisa berenang',
      'Manusia purba berjalan tegak',
      'Manusia purba memelihara hewan',
      'Manusia purba mengenal api',
    ],
    correctIndex: 1,
    explanation:
        'Bentuk tulang paha yang lurus menunjukkan pemiliknya berjalan '
        'tegak. Dari sinilah nama "erectus" berasal.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Bagaimana alat batu Palaeolitikum dibuat?',
    options: [
      'Dicetak dari logam cair',
      'Dipangkas dengan memukul batu',
      'Dipahat dengan besi',
      'Diasah halus hingga mengkilap',
    ],
    correctIndex: 1,
    explanation:
        'Teknik pemangkasan (knapping) memukul batu hingga terlepas '
        'serpihan sehingga tepinya tajam.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Stegodon, yang fosilnya ditemukan di Trinil, adalah kerabat purba...',
    options: ['Harimau', 'Gajah', 'Kuda', 'Badak'],
    correctIndex: 1,
    explanation:
        'Stegodon adalah kerabat purba gajah dengan gading yang sangat '
        'panjang.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Fosil manusia Wajak (Tulungagung) tergolong...',
    options: [
      'Homo sapiens awal',
      'Homo erectus',
      'Kera besar',
      'Australopithecus',
    ],
    correctIndex: 0,
    explanation:
        'Manusia Wajak adalah Homo sapiens awal, jauh lebih muda daripada '
        'Homo erectus Trinil.',
  ),
  QuizQuestion(
    era: 'Mesolitikum',
    question: 'Kebudayaan Sampung terkenal dengan alat dari bahan...',
    options: ['Tulang', 'Perunggu', 'Besi', 'Kaca'],
    correctIndex: 0,
    explanation:
        'Gua Lawa Sampung menghasilkan banyak alat tulang, sehingga '
        'dikenal sebagai Sampung Bone Culture.',
  ),
  QuizQuestion(
    era: 'Mesolitikum',
    question: 'Gua Lawa, situs terkenal Kebudayaan Sampung, terletak di...',
    options: ['Ponorogo', 'Sampang', 'Banyuwangi', 'Lamongan'],
    correctIndex: 0,
    explanation:
        'Gua Lawa berada di Sampung, Ponorogo, diteliti van Stein '
        'Callenfels pada 1928-1931.',
  ),
  QuizQuestion(
    era: 'Mesolitikum',
    question: 'Mikrolit digunakan terutama sebagai...',
    options: [
      'Perhiasan raja',
      'Mata panah dan mata pisau kecil',
      'Alat tulis',
      'Uang',
    ],
    correctIndex: 1,
    explanation:
        'Serpih mungil berbentuk geometris dipasang pada tangkai menjadi '
        'mata panah atau pisau majemuk.',
  ),
  QuizQuestion(
    era: 'Neolitikum',
    question: 'Ciri utama Zaman Neolitikum adalah...',
    options: [
      'Hidup berpindah-pindah',
      'Bercocok tanam dan hidup menetap',
      'Membuat monumen raksasa saja',
      'Berdagang dengan uang logam',
    ],
    correctIndex: 1,
    explanation:
        'Neolitikum ditandai pertanian, peternakan, kehidupan menetap, '
        'dan gerabah.',
  ),
  QuizQuestion(
    era: 'Neolitikum',
    question: 'Apa pembeda utama alat batu Neolitik dari Palaeolitik?',
    options: [
      'Lebih besar dan kasar',
      'Diasah dan dipoles halus',
      'Terbuat dari besi',
      'Tidak punya tajaman',
    ],
    correctIndex: 1,
    explanation:
        'Beliung dan kapak Neolitik diasah dan dipoles sehingga permukaannya '
        'halus.',
  ),
  QuizQuestion(
    era: 'Neolitikum',
    question: 'Gerabah dianggap tanda manusia sudah...',
    options: ['Menetap', 'Berburu mamut', 'Tinggal di laut', 'Mengenal listrik'],
    correctIndex: 0,
    explanation:
        'Bejana tanah mudah pecah, jadi cocok bagi masyarakat yang menetap.',
  ),
  QuizQuestion(
    era: 'Megalitikum',
    question: 'Menhir adalah...',
    options: [
      'Meja batu',
      'Batu tegak monumen',
      'Peti mati batu',
      'Kapak perunggu',
    ],
    correctIndex: 1,
    explanation:
        'Menhir adalah batu tegak yang didirikan sebagai tugu pemujaan '
        'arwah leluhur.',
  ),
  QuizQuestion(
    era: 'Megalitikum',
    question: 'Dolmen paling tepat digambarkan sebagai...',
    options: ['Patung manusia', 'Meja batu', 'Gelang batu', 'Kuburan kayu'],
    correctIndex: 1,
    explanation:
        'Dolmen adalah lempeng batu besar yang ditopang batu penyangga, '
        'dipakai sebagai altar atau penutup kubur.',
  ),
  QuizQuestion(
    era: 'Megalitikum',
    question: 'Sarkofagus adalah...',
    options: ['Alat berburu', 'Peti jenazah batu', 'Perhiasan', 'Rumah adat'],
    correctIndex: 1,
    explanation:
        'Sarkofagus berupa peti jenazah batu berbentuk palung dan tutup, '
        'biasanya untuk tokoh yang dihormati.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Kapak corong dibuat dari...',
    options: ['Batu andesit', 'Perunggu', 'Tulang', 'Kayu jati'],
    correctIndex: 1,
    explanation:
        'Kapak corong terbuat dari perunggu, campuran tembaga dan timah, '
        'dengan rongga di pangkal untuk tangkai.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Nekara perunggu dipakai terutama sebagai...',
    options: [
      'Genderang upacara',
      'Wadah masak sehari-hari',
      'Senjata perang',
      'Cermin',
    ],
    correctIndex: 0,
    explanation:
        'Nekara dipakai dalam upacara, termasuk memanggil hujan, dan '
        'sebagai penanda status.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Budaya Dongson, yang memengaruhi nekara di Nusantara, berasal dari...',
    options: ['Peru', 'Vietnam utara', 'Mesir', 'Jepang'],
    correctIndex: 1,
    explanation:
        'Budaya Dongson berasal dari kawasan Vietnam utara dan '
        'pengaruhnya menyebar lewat perdagangan.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Pecahan tipis bertepi tajam yang terlepas saat batu inti dipukul disebut...',
    options: ['Serpih (flake)', 'Beliung', 'Nekara', 'Pipisan'],
    correctIndex: 0,
    explanation:
        'Serpih dipakai langsung sebagai pisau tanpa dibentuk lagi.',
  ),
  QuizQuestion(
    era: 'Mesolitikum',
    question: 'Siapa yang meneliti Gua Lawa, Sampung, pada 1928-1931?',
    options: [
      'van Stein Callenfels',
      'Eugene Dubois',
      'Teuku Jacob',
      'von Koenigswald',
    ],
    correctIndex: 0,
    explanation:
        'Van Stein Callenfels meneliti Gua Lawa dan mengenalkan '
        'Kebudayaan Sampung.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Fosil manusia Wajak diperkirakan berusia sekitar...',
    options: [
      '5.000 tahun',
      '37.000 - 28.000 tahun',
      '1,5 juta tahun',
      '500 tahun',
    ],
    correctIndex: 1,
    explanation:
        'Penanggalan terbaru menunjukkan usia manusia Wajak puluhan ribu '
        'tahun, jauh lebih muda daripada Homo erectus.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Perunggu adalah campuran dari...',
    options: [
      'Besi dan karbon',
      'Tembaga dan timah',
      'Emas dan perak',
      'Seng dan aluminium',
    ],
    correctIndex: 1,
    explanation: 'Perunggu dibuat dengan mencampur tembaga dan timah.',
  ),
  QuizQuestion(
    era: 'Megalitikum',
    question: 'Tradisi megalitik terutama berkaitan dengan...',
    options: [
      'Perdagangan rempah',
      'Pemujaan arwah leluhur',
      'Pembuatan senjata',
      'Penanaman padi',
    ],
    correctIndex: 1,
    explanation:
        'Monumen batu besar didirikan untuk menghormati arwah leluhur.',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Siapa penemu fosil Manusia Jawa di Trinil?',
    options: [
      'Raden Saleh',
      'Eugene Dubois',
      'R.P. Soejono',
      'Teuku Jacob',
    ],
    correctIndex: 1,
    explanation:
        'Eugene Dubois menemukannya pada 1891-1892 di tepi Bengawan Solo.',
  ),
  QuizQuestion(
    era: 'Neolitikum',
    question: 'Teknik membuat gerabah dengan pemukul dan penahan disebut...',
    options: ['Tatap-pelandas', 'Lilin hilang', 'Knapping', 'Pahat basah'],
    correctIndex: 0,
    explanation:
        'Tatap adalah pemukul dan pelandas adalah penahan di sisi dalam.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Manik-manik kaca kuno di Nusantara menunjukkan hubungan dagang dengan...',
    options: ['Eropa utara', 'India', 'Amerika', 'Australia'],
    correctIndex: 1,
    explanation:
        'Sebagian manik kaca berasal dari India lewat jalur dagang laut.',
  ),
  QuizQuestion(
    era: 'Mesolitikum',
    question: 'Pipisan dan batu giling dipakai untuk...',
    options: [
      'Menghaluskan biji-bijian dan pewarna',
      'Menangkap ikan',
      'Membuat perahu',
      'Menyimpan air',
    ],
    correctIndex: 0,
    explanation:
        'Landasan dan penggiling dipakai untuk menumbuk makanan dan oker.',
  ),
  QuizQuestion(
    era: 'Megalitikum',
    question: 'Kata "dolmen" berasal dari bahasa Breton dan berarti...',
    options: ['Batu tegak', 'Meja batu', 'Peti batu', 'Patung batu'],
    correctIndex: 1,
    explanation: 'Dolmen berarti "meja batu".',
  ),
  QuizQuestion(
    era: 'Palaeolitikum',
    question: 'Temuan pertama Dubois di Trinil pada 1891 berupa...',
    options: ['Gigi geraham', 'Kapak batu', 'Tulang paha', 'Gading'],
    correctIndex: 0,
    explanation:
        'Sebuah geraham ditemukan lebih dulu; tak lama kemudian atap '
        'tengkorak muncul.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Warna hijau pada perunggu tua disebut...',
    options: ['Patina', 'Oker', 'Enamel', 'Kerak'],
    correctIndex: 0,
    explanation: 'Patina terbentuk saat perunggu bereaksi dengan udara dan tanah.',
  ),
  QuizQuestion(
    era: 'Zaman Logam',
    question: 'Mengapa temuan benda besi utuh tergolong langka?',
    options: [
      'Besi mudah berkarat di tanah lembap',
      'Besi belum dikenal manusia',
      'Besi selalu dilebur kembali oleh alam',
      'Besi hanya ada di laut',
    ],
    correctIndex: 0,
    explanation: 'Karat membuat besi rapuh dan hancur dalam waktu lama.',
  ),
];
