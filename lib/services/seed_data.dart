import '../models/artifact.dart';
import '../models/museum.dart';

/// Data awal koleksi. Narasi disusun dari literatur populer arkeologi
/// Indonesia untuk tujuan edukasi; periksa kembali ke sumber museum/BPCB
/// bila dipakai untuk keperluan akademik.
class SeedData {
  SeedData._();

  static const List<Artifact> artifacts = [
    // ------------------------------------------------------------------
    // PALAEOLITIKUM
    // ------------------------------------------------------------------
    Artifact(
      name: 'Kapak Genggam Trinil',
      summary: 'Batu yang dipukul-pukul hingga tajam, digenggam langsung sebagai alat serba guna oleh manusia purba.',
      significance: 'Memperlihatkan bahwa Homo erectus di lembah Bengawan Solo sudah mampu merancang alat, bukan sekadar memakai batu seadanya.',
      latitude: -7.38,
      longitude: 111.43,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Kawasan Bengawan Solo purba, Ngawi',
      material: 'Batu rijang (chert)',
      period: '± 800.000 - 100.000 tahun lalu (Pleistosen)',
      ageYears: 800000,
      dimensions: '± 12 - 18 cm',
      culture: 'Tradisi alat batu Palaeolitik Jawa',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/kapak_genggam.jpg',
      description:
          'Kapak genggam dari batu rijang keabu-abuan yang dipamerkan sebagai '
          'gambaran teknologi manusia purba di lembah Bengawan Solo. Bentuknya '
          'memanjang dengan bekas pangkasan di kedua sisi, dibuat dengan cara '
          'dipukul-pukul (knapping) memakai batu pemukul. Alat seperti ini '
          'digenggam langsung tanpa tangkai.',
      functionPast:
          'Alat serba guna: memotong daging hasil buruan, menguliti hewan, '
          'memotong kayu lunak, dan menggali umbi.',
      functionToday:
          'Koleksi pamer Museum Trinil yang membantu pengunjung membayangkan '
          'kehidupan Homo erectus; juga bahan studi teknologi batu.',
      discoveryInfo:
          'Alat batu dari kawasan Bengawan Solo purba, lingkungan yang sama '
          'dengan tempat Eugene Dubois menemukan fosil Homo erectus pada 1891.',
      characteristics:
          'Bentuk memanjang tanpa tangkai\n'
          'Pangkasan kasar di kedua sisi (bifasial)\n'
          'Pangkal tebal untuk genggaman, ujung meruncing\n'
          'Permukaan masih menyisakan kulit batu asli',
      funFacts:
          'Dibuat tanpa logam: hanya batu dipukul dengan batu lain.\n'
          'Satu kapak bisa dibuat dalam hitungan menit oleh pengrajin terampil.',
    ),
    Artifact(
      name: 'Kapak Genggam Pacitan',
      summary: 'Kapak batu kasar khas Pacitan: tajam di satu sisi, halus di sisi yang digenggam.',
      significance: 'Menjadikan Pacitan salah satu kawasan prasejarah terpenting di Jawa; tradisinya dinamai Kebudayaan Pacitanian.',
      latitude: -8.2,
      longitude: 111.1,
      era: 'Palaeolitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Pacitan, Jawa Timur',
      material: 'Batu kali kersikan (kalsedon/rijang)',
      period: 'Pleistosen Tengah - Akhir (ratusan ribu tahun lalu)',
      ageYears: 200000,
      dimensions: '± 10 - 15 cm',
      culture: 'Kebudayaan Pacitanian',
      discoveryYear: '1935',
      thumbnail: 'assets/images/artifacts/kapak_pacitan.jpg',
      description:
          'Kapak perimbas/genggam khas Kebudayaan Pacitanian. Bahannya batu '
          'kali yang dipangkas pada satu sisi sehingga membentuk tajaman, '
          'sementara sisi lain dibiarkan halus agar nyaman digenggam. '
          'Ribuan alat serupa tersebar di sepanjang aliran sungai di Pacitan.',
      functionPast:
          'Memotong, menetak kayu, memecah tulang, dan menggali umbi-umbian.',
      functionToday:
          'Objek penelitian teknologi batu dan ikon Pacitan sebagai '
          'kawasan prasejarah penting di Pulau Jawa.',
      discoveryInfo:
          'Dikenali oleh G.H.R. von Koenigswald pada 1935 di sekitar Punung, '
          'Pacitan, dan kemudian dikaji lebih jauh oleh banyak peneliti.',
      characteristics:
          'Dipangkas pada satu sisi (monofasial)\n'
          'Sisi punggung masih berkulit batu\n'
          'Tajaman tebal dan kuat untuk menetak\n'
          'Berbahan batu kali yang melimpah di Pacitan',
      funFacts:
          'Kebudayaan Pacitanian dinamai dari tempat penemuannya.\n'
          'Karst Pacitan masuk Geopark Dunia UNESCO (Gunung Sewu).',
    ),
    Artifact(
      name: 'Alat Serpih Batu (Flake Tool)',
      summary: 'Pecahan batu setajam pisau yang langsung dipakai tanpa dibentuk lagi.',
      significance: 'Menunjukkan cara paling sederhana manusia purba membuat "pisau" dan memanfaatkan sisa pemangkasan batu.',
      latitude: -7.42,
      longitude: 111.4,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Kawasan Bengawan Solo (Ngawi - Sragen)',
      material: 'Batu rijang (chert)',
      period: 'Pleistosen (ratusan ribu tahun lalu)',
      ageYears: 500000,
      dimensions: '± 3 - 8 cm',
      culture: 'Tradisi alat serpih Pleistosen Jawa',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/flake.jpg',
      description:
          'Serpih batu adalah pecahan tajam yang terlepas saat sebuah batu '
          'inti dipukul. Tepinya setajam pisau sehingga langsung bisa dipakai '
          'tanpa dibentuk lagi. Pada permukaannya tampak riak gelombang '
          'akibat hantaman, ciri khas pemangkasan batu.',
      functionPast:
          'Pisau untuk menyayat daging, menguliti, mengerik kayu, dan '
          'menyiapkan kulit binatang.',
      functionToday:
          'Bahan studi rantai pembuatan alat batu (chaîne opératoire) dan '
          'cara hidup manusia purba.',
      discoveryInfo:
          'Ditemukan bersama fosil di endapan sungai purba Bengawan Solo '
          'pada wilayah yang melintasi Jawa Timur dan Jawa Tengah.',
      characteristics:
          'Tepi sangat tajam\n'
          'Bidang pukul (striking platform) terlihat jelas\n'
          'Riak gelombang di permukaan belakang\n'
          'Bentuk tidak beraturan',
      funFacts:
          'Serpih adalah "pisau cukur" pertama umat manusia.\n'
          'Tepi serpih bisa lebih tajam daripada pisau bedah modern.',
    ),
    Artifact(
      name: 'Fosil Tengkorak Pithecanthropus erectus',
      summary: 'Atap tengkorak Manusia Jawa yang ditemukan Dubois di tepi Bengawan Solo pada 1891.',
      significance: 'Bukti fisik awal bahwa manusia purba pernah hidup di Asia, yang mengubah pemahaman dunia tentang evolusi manusia.',
      latitude: -7.3761,
      longitude: 111.4253,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Trinil, Ngawi, Jawa Timur',
      material: 'Tulang terfosilkan',
      period: '± 540.000 - 430.000 tahun lalu (penanggalan terbaru)',
      ageYears: 500000,
      dimensions: 'Volume otak ± 940 cm³',
      culture: 'Homo erectus ("Manusia Jawa")',
      discoveryYear: '1891',
      thumbnail: 'assets/images/artifacts/fosil.jpg',
      description:
          'Atap tengkorak Homo erectus yang ditemukan Eugene Dubois di tepi '
          'Bengawan Solo. Dahi rendah, tulang alis tebal, dan volume otak '
          'sekitar 940 cm³, lebih kecil dari manusia modern tetapi jauh '
          'lebih besar dari kera. Replikanya dapat dilihat di Museum Trinil.',
      functionPast:
          'Bukan artefak buatan, melainkan sisa biologis manusia purba '
          'yang menjadi petunjuk evolusi manusia.',
      functionToday:
          'Ikon sains Indonesia; fosil asli disimpan di Naturalis (Leiden, '
          'Belanda), sedangkan replikanya dipamerkan untuk edukasi.',
      discoveryInfo:
          'Ditemukan pada 1891 oleh tim Eugene Dubois di tepi Bengawan Solo, '
          'dekat Desa Kawu, Ngawi. Dubois menamainya Pithecanthropus erectus.',
      characteristics:
          'Dahi rendah dan melandai\n'
          'Tonjolan alis (supraorbital torus) menonjol\n'
          'Dinding tengkorak tebal\n'
          'Volume otak ± 940 cm³',
      funFacts:
          'Dubois sengaja datang ke Hindia Belanda untuk mencari "mata rantai '
          'yang hilang" evolusi manusia.\n'
          'Ini fosil Homo erectus pertama yang ditemukan di luar Eropa.',
    ),
    Artifact(
      name: 'Tulang Paha Trinil (Femur)',
      summary: 'Tulang paha yang lurus membuktikan Manusia Jawa berjalan tegak dengan dua kaki.',
      significance: 'Dari tulang inilah nama "erectus" (tegak) lahir. Berjalan tegak membebaskan tangan untuk membuat dan membawa alat.',
      latitude: -7.378,
      longitude: 111.428,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Trinil, Ngawi, Jawa Timur',
      material: 'Tulang terfosilkan',
      period: '± 540.000 - 430.000 tahun lalu',
      ageYears: 500000,
      dimensions: '± 45 cm',
      culture: 'Homo erectus',
      discoveryYear: '1892',
      thumbnail: 'assets/images/artifacts/femur.jpg',
      description:
          'Tulang paha panjang dan lurus yang ditemukan sekitar 15 meter dari '
          'lokasi atap tengkorak Trinil. Bentuknya menyerupai tulang paha '
          'manusia modern sehingga menjadi bukti kuat bahwa pemiliknya '
          'berjalan tegak dengan dua kaki.',
      functionPast:
          'Penopang tubuh saat berjalan dan berlari tegak (bipedal).',
      functionToday:
          'Bukti anatomi berjalan tegak yang melahirkan nama "erectus" '
          '(tegak) pada Manusia Jawa.',
      discoveryInfo:
          'Ditemukan tahun 1892 oleh tim Dubois, setahun setelah atap '
          'tengkorak Trinil.',
      characteristics:
          'Batang tulang panjang dan lurus\n'
          'Sudut sendi lutut mirip manusia modern\n'
          'Permukaan terfosilkan berwarna kecoklatan',
      funFacts:
          'Dari tulang inilah Dubois menyimpulkan makhluk itu berjalan tegak.\n'
          'Selama puluhan tahun para ilmuwan memperdebatkannya.',
    ),
    Artifact(
      name: 'Gading Stegodon',
      summary: 'Gading panjang kerabat gajah purba yang hidup sezaman dengan Manusia Jawa.',
      significance: 'Membantu para ahli merekonstruksi lingkungan purba dan menentukan umur lapisan tanah tempat fosil manusia ditemukan.',
      latitude: -7.374,
      longitude: 111.422,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Lapisan Pleistosen Trinil, Ngawi',
      material: 'Gading terfosilkan',
      period: 'Pleistosen (± 1,2 juta - 500.000 tahun lalu)',
      ageYears: 1200000,
      dimensions: 'Gading bisa lebih dari 2 meter',
      culture: 'Fauna Trinil',
      discoveryYear: 'Abad ke-19 hingga kini',
      thumbnail: 'assets/images/artifacts/stegodon.jpg',
      description:
          'Stegodon adalah kerabat purba gajah dengan sepasang gading sangat '
          'panjang. Fosilnya melimpah di endapan Trinil dan menjadi bagian '
          'dari "Fauna Trinil", kumpulan hewan yang hidup sezaman dengan '
          'Homo erectus di dataran banjir Bengawan Solo.',
      functionPast:
          'Gading dipakai untuk bertarung, menggali, dan mencari makan.',
      functionToday:
          'Penanda umur lapisan tanah (biostratigrafi) dan bahan '
          'rekonstruksi lingkungan purba Jawa.',
      discoveryInfo:
          'Fosil fauna ditemukan bersama fosil manusia purba pada ekskavasi '
          'Dubois dan penelitian lanjutan di Trinil.',
      characteristics:
          'Gading panjang dan melengkung\n'
          'Berhubungan dengan gajah modern\n'
          'Punah di Pleistosen\n'
          'Hidup di dataran sungai dan hutan terbuka',
      funFacts:
          'Manusia purba Trinil berburu dan berbagi lanskap dengan Stegodon.\n'
          'Fauna Trinil juga mencakup rusa, banteng, dan hippopotamus purba.',
    ),
    Artifact(
      name: 'Fosil Manusia Wajak',
      summary: 'Tengkorak manusia modern awal dari Tulungagung, jauh lebih muda daripada Manusia Jawa.',
      significance: 'Bukti awal Homo sapiens di Jawa, sehingga pulau ini dihuni lebih dari satu jenis manusia dari masa ke masa.',
      latitude: -8.1,
      longitude: 111.88,
      era: 'Palaeolitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Wajak, Campurdarat, Tulungagung',
      material: 'Tulang terfosilkan',
      period: '± 37.000 - 28.000 tahun lalu',
      ageYears: 37000,
      dimensions: 'Tengkorak dewasa',
      culture: 'Homo sapiens awal',
      discoveryYear: '1888',
      thumbnail: 'assets/images/artifacts/wajak.jpg',
      description:
          'Tengkorak manusia modern awal yang ditemukan di sebuah gua kecil di '
          'Wajak. Berbeda dari Homo erectus, wajahnya lebih datar dan '
          'tengkoraknya lebih tinggi, menandai kehadiran Homo sapiens di Jawa '
          'pada akhir Zaman Es.',
      functionPast:
          'Sisa biologis manusia pemburu-peramu pada Zaman Es terakhir.',
      functionToday:
          'Salah satu bukti tertua Homo sapiens di Nusantara; fosil asli '
          'berada di Belanda, replikanya dipamerkan untuk edukasi.',
      discoveryInfo:
          'Ditemukan pada 1888 oleh B.D. van Rietschoten, lalu dikaji oleh '
          'Eugene Dubois, yang menamainya Homo wajakensis.',
      characteristics:
          'Tengkorak tinggi dan wajah relatif datar\n'
          'Tonjolan alis kecil\n'
          'Ciri manusia modern awal',
      funFacts:
          'Ditemukan lebih dulu daripada fosil Trinil.\n'
          'Penanggalan ulang menunjukkan umurnya puluhan ribu tahun, bukan '
          'ratusan ribu.',
    ),
    Artifact(
      name: 'Kapak Genggam Batu Anjuk Ladang',
      summary: 'Kapak batu andesit dari Nganjuk, bukti ada hunian jauh sebelum masa kerajaan.',
      significance: 'Mengingatkan bahwa satu lokasi bisa menyimpan banyak lapisan sejarah: dari alat batu hingga prasasti abad ke-10.',
      latitude: -7.6,
      longitude: 111.9,
      era: 'Palaeolitikum',
      museum: 'Museum Anjuk Ladang',
      origin: 'Nganjuk, Jawa Timur',
      material: 'Batu andesit',
      period: 'Pleistosen Akhir (puluhan ribu tahun lalu)',
      ageYears: 50000,
      dimensions: '± 10 - 14 cm',
      culture: 'Tradisi alat batu Palaeolitik',
      discoveryYear: 'Survei arkeologi abad ke-20',
      thumbnail: 'assets/images/artifacts/kapak_genggam.jpg',
      description:
          'Kapak genggam dari batu andesit yang ditemukan di sekitar kompleks '
          'situs Anjuk Ladang. Situs yang terkenal dengan prasasti abad ke-10 '
          'ini ternyata menyimpan lapisan budaya yang jauh lebih tua.',
      functionPast:
          'Alat potong kayu dan senjata berburu pada masa Pleistosen akhir.',
      functionToday:
          'Memperlihatkan bahwa kawasan Nganjuk dihuni jauh sebelum '
          'masa kerajaan.',
      discoveryInfo:
          'Dikumpulkan dalam survei arkeologi di kawasan Anjuk Ladang oleh '
          'instansi purbakala setempat.',
      characteristics:
          'Berbahan andesit yang lebih sulit dipangkas\n'
          'Pangkasan lebar dan dangkal\n'
          'Genggaman nyaman di satu sisi',
      funFacts:
          'Satu situs bisa menyimpan lapisan budaya dari puluhan ribu tahun.\n'
          'Prasasti Anjuk Ladang (937 M) menjadi dasar hari jadi Kabupaten Nganjuk.',
    ),

    // ------------------------------------------------------------------
    // MESOLITIKUM
    // ------------------------------------------------------------------
    Artifact(
      name: 'Mikrolit Mata Panah',
      summary: 'Serpihan batu sekecil kuku yang dirangkai menjadi mata panah.',
      significance: 'Penanda kemajuan teknik berburu dengan busur dan panah pada masa Mesolitikum.',
      latitude: -7.87,
      longitude: 111.46,
      era: 'Mesolitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Gua-gua kapur Jawa Timur (Ponorogo & Pacitan)',
      material: 'Batu kersik (chert)',
      period: '± 12.000 - 4.000 tahun lalu',
      ageYears: 12000,
      dimensions: '± 1 - 3 cm',
      culture: 'Budaya gua Mesolitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/mikrolit.jpg',
      description:
          'Mikrolit adalah serpihan batu mungil yang sengaja dibentuk '
          'geometris: segitiga, trapesium, atau bulan sabit. Beberapa '
          'mikrolit dirangkai pada tangkai kayu menjadi mata panah atau '
          'pisau majemuk.',
      functionPast:
          'Mata panah, mata tombak kecil, dan tepi tajam pada pisau '
          'komposit untuk berburu.',
      functionToday:
          'Penanda budaya Mesolitik dan bukti kemajuan teknik berburu '
          'dengan busur dan panah.',
      discoveryInfo:
          'Ditemukan dalam ekskavasi gua-gua hunian di kawasan karst Jawa '
          'Timur, antara lain Ponorogo dan Pacitan.',
      characteristics:
          'Ukuran sangat kecil\n'
          'Bentuk geometris (segitiga, trapesium)\n'
          'Dipasang pada tangkai kayu atau tulang\n'
          'Berbahan batu kersik yang tajam',
      funFacts:
          'Satu panah bisa memiliki beberapa mikrolit sekaligus.\n'
          'Ukurannya sebesar kuku jari!',
    ),
    Artifact(
      name: 'Alat Tulang Sampung',
      summary: 'Penusuk dari tulang hewan yang diasah, khas Gua Lawa Sampung.',
      significance: 'Bahan organik jarang bertahan ribuan tahun, jadi alat ini bukti langka keterampilan membuat alat selain dari batu.',
      latitude: -7.92,
      longitude: 111.63,
      era: 'Mesolitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Gua Lawa, Sampung, Ponorogo',
      material: 'Tulang hewan (kijang, babi)',
      period: '± 10.000 - 4.000 tahun lalu',
      ageYears: 10000,
      dimensions: '± 8 - 15 cm',
      culture: 'Kebudayaan Sampung (Sampung Bone Culture)',
      discoveryYear: '1928 - 1931',
      thumbnail: 'assets/images/artifacts/tulang.jpg',
      description:
          'Alat runcing dari tulang panjang hewan yang diasah ujungnya. '
          'Permukaannya halus karena sering dipakai. Temuan di Gua Lawa '
          'Sampung begitu khas sehingga kebudayaan ini dinamai Kebudayaan '
          'Sampung.',
      functionPast:
          'Penusuk, pelubang kulit, pengeruk, dan penggali umbi.',
      functionToday:
          'Contoh langka alat berbahan organik dan penanda budaya gua '
          'Mesolitik di Jawa.',
      discoveryInfo:
          'Diteliti oleh van Stein Callenfels pada 1928-1931 di Gua Lawa, '
          'Sampung, Ponorogo.',
      characteristics:
          'Ujung diasah runcing\n'
          'Berbahan tulang panjang hewan buruan\n'
          'Permukaan halus karena pemakaian',
      funFacts:
          'Tulang mudah lapuk, jadi alat tulang yang selamat itu langka.\n'
          'Gua Lawa Sampung menghasilkan banyak sekali alat tulang dan tanduk.',
    ),
    Artifact(
      name: 'Pipisan dan Batu Giling',
      summary: 'Landasan dan penggiling batu untuk menumbuk makanan dan pewarna.',
      significance: 'Menunjukkan manusia sudah mengolah makanan dan memakai pewarna oker, termasuk untuk upacara.',
      era: 'Mesolitikum',
      museum: 'Museum Brawijaya',
      origin: 'Gua hunian prasejarah, Jawa Timur',
      material: 'Batu andesit / batu pasir',
      period: '± 10.000 - 4.000 tahun lalu',
      ageYears: 10000,
      dimensions: 'Landasan ± 30 cm',
      culture: 'Budaya gua Mesolitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/pipisan.jpg',
      description:
          'Sepasang alat: landasan batu berpermukaan datar atau cekung '
          '(pipisan) dan batu penggiling berbentuk silinder. Dipakai '
          'menghaluskan biji-bijian, umbi, dan bahan pewarna alami seperti '
          'oker merah.',
      functionPast:
          'Menumbuk dan menggiling makanan serta menyiapkan cat merah '
          'dari oker untuk upacara.',
      functionToday:
          'Bukti pengolahan makanan dan ritual sederhana pada masyarakat '
          'berburu-meramu.',
      discoveryInfo:
          'Ditemukan di lapisan hunian gua pada beberapa ekskavasi di '
          'Jawa Timur.',
      characteristics:
          'Landasan datar atau cekung\n'
          'Batu penggiling berbentuk silinder\n'
          'Sering menyisakan noda oker merah',
      funFacts:
          'Oker merah sering dipakai pada upacara penguburan.\n'
          'Alat serupa masih dipakai di sebagian desa hingga kini.',
    ),

    // ------------------------------------------------------------------
    // NEOLITIKUM
    // ------------------------------------------------------------------
    Artifact(
      name: 'Kapak Persegi (Beliung Persegi)',
      summary: 'Kapak batu yang diasah halus dan dipoles, dipasang pada tangkai kayu.',
      significance: 'Penanda Zaman Neolitik dan petunjuk persebaran penutur Austronesia di Nusantara.',
      era: 'Neolitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Situs Neolitik Jawa Timur (Pacitan & Tulungagung)',
      material: 'Kalsedon (batu kersikan)',
      period: '± 4.000 - 2.500 tahun lalu',
      ageYears: 4000,
      dimensions: '± 8 - 15 cm',
      culture: 'Budaya Neolitik Austronesia',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/kapak_persegi.jpg',
      description:
          'Beliung persegi berpenampang lonjong-persegi dengan tajaman di '
          'satu ujung. Seluruh permukaannya diasah dan dipoles halus, ciri '
          'utama Zaman Neolitik. Persebarannya yang luas menjadi petunjuk '
          'migrasi dan jejaring perdagangan antarpulau.',
      functionPast:
          'Menebang pohon, membuka ladang, mengerjakan kayu perahu dan rumah; '
          'sebagian juga menjadi benda berharga.',
      functionToday:
          'Penanda peralihan ke cara hidup bercocok tanam dan bukti '
          'persebaran penutur Austronesia.',
      discoveryInfo:
          'Ditemukan di berbagai situs permukaan dan ekskavasi di '
          'Jawa Timur oleh balai arkeologi dan pelestari cagar budaya.',
      characteristics:
          'Seluruh permukaan diasah halus\n'
          'Penampang persegi panjang\n'
          'Tajaman miring pada satu ujung\n'
          'Dipasang pada tangkai kayu',
      funFacts:
          'Bentuk beliung sama muncul dari Taiwan hingga Pasifik.\n'
          'Mengasah satu beliung bisa memakan waktu berhari-hari.',
    ),
    Artifact(
      name: 'Gerabah Prasejarah Anjuk Ladang',
      summary: 'Bejana tanah liat bakar berhias garis dan segitiga.',
      significance: 'Bukti manusia mulai menetap dan menyimpan hasil panen; pola hiasnya membantu melacak persebaran budaya.',
      latitude: -7.59,
      longitude: 111.92,
      era: 'Neolitikum',
      museum: 'Museum Anjuk Ladang',
      origin: 'Situs Anjuk Ladang, Nganjuk',
      material: 'Tanah liat bakar',
      period: '± 4.000 - 2.000 tahun lalu',
      ageYears: 3500,
      dimensions: 'Diameter mulut ± 15 - 25 cm',
      culture: 'Budaya Neolitik Austronesia',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/gerabah.jpg',
      description:
          'Pecahan dan bejana gerabah bertepi terbuka dengan dinding tebal. '
          'Permukaannya memperlihatkan bekas tatap-pelandas (alat pemukul '
          'dan penahan) serta hiasan garis dan segitiga yang digores.',
      functionPast:
          'Menyimpan air dan bijian, memasak, serta bekal kubur untuk '
          'upacara.',
      functionToday:
          'Bukti kehidupan menetap dan teknologi tembikar di Nusantara; '
          'pola hiasnya membantu melacak persebaran budaya.',
      discoveryInfo:
          'Ditemukan oleh tim purbakala di situs Anjuk Ladang, Nganjuk.',
      characteristics:
          'Dibuat dengan teknik tatap-pelandas\n'
          'Hiasan garis dan segitiga gores\n'
          'Dibakar di api terbuka (suhu rendah)\n'
          'Dinding tebal dan agak kasar',
      funFacts:
          'Gerabah menandakan manusia sudah menetap, sebab bejana tanah '
          'mudah pecah dibawa berpindah.\n'
          'Tradisi membuat gerabah masih hidup di banyak desa Jawa.',
    ),
    Artifact(
      name: 'Gelang Batu Neolitik',
      summary: 'Perhiasan batu berbentuk cincin yang dibuat dengan pengeboran sabar.',
      significance: 'Menunjukkan seni dan teknologi pengasahan batu, sekaligus status sosial pemakainya.',
      era: 'Neolitikum',
      museum: 'Museum Brawijaya',
      origin: 'Situs Neolitik Jawa Timur',
      material: 'Batu halus (kalsedon / batu pualam)',
      period: '± 4.000 - 2.500 tahun lalu',
      ageYears: 3800,
      dimensions: 'Diameter ± 6 - 8 cm',
      culture: 'Budaya Neolitik Austronesia',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/gelang.jpg',
      description:
          'Gelang dari batu yang dilubangi dan diasah halus hingga '
          'berbentuk cincin sempurna. Pembuatannya sangat teliti: lubang '
          'dibor perlahan dengan batu dan pasir, bukan dengan logam.',
      functionPast:
          'Perhiasan, penanda status, dan bekal kubur.',
      functionToday:
          'Bukti kemampuan seni dan teknologi pengasahan batu masyarakat '
          'Neolitik.',
      discoveryInfo:
          'Ditemukan pada beberapa situs hunian dan kubur Neolitik di '
          'Jawa Timur.',
      characteristics:
          'Berbentuk cincin simetris\n'
          'Permukaan dipoles halus\n'
          'Lubang dibuat dengan pengeboran batu',
      funFacts:
          'Pelubangan dilakukan dengan pasir dan air, memakan waktu lama.\n'
          'Gelang kecil kadang dipakai anak-anak.',
    ),

    // ------------------------------------------------------------------
    // MEGALITIKUM
    // ------------------------------------------------------------------
    Artifact(
      name: 'Menhir Bondowoso',
      summary: 'Batu tegak setinggi manusia atau lebih untuk menghormati leluhur.',
      significance: 'Bukti kepercayaan pada arwah leluhur dan kerja sama besar masyarakat yang mendirikannya.',
      latitude: -7.92,
      longitude: 113.8,
      era: 'Megalitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Bondowoso, Jawa Timur',
      material: 'Batu andesit',
      period: '± 3.500 - 1.500 tahun lalu',
      ageYears: 3000,
      dimensions: 'Tinggi bervariasi 1 - 4 m',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Inventarisasi cagar budaya',
      thumbnail: 'assets/images/artifacts/menhir.jpg',
      description:
          'Menhir adalah batu tegak yang sengaja didirikan sebagai monumen. '
          'Bondowoso dikenal sebagai salah satu pusat tradisi megalitik di '
          'Jawa Timur, dengan banyak menhir, dolmen, dan kubur batu.',
      functionPast:
          'Tugu pemujaan arwah leluhur dan penanda wilayah serta '
          'kedudukan seseorang.',
      functionToday:
          'Cagar budaya yang dilindungi dan objek kajian kepercayaan '
          'nenek moyang.',
      discoveryInfo:
          'Dicatat dalam inventarisasi dan survei cagar budaya di '
          'Kabupaten Bondowoso.',
      characteristics:
          'Batu tegak tanpa pahatan rumit\n'
          'Sering berkelompok membentuk halaman upacara\n'
          'Didirikan dengan tenaga bersama (gotong royong)',
      funFacts:
          'Menarik sebuah batu raksasa butuh puluhan orang.\n'
          'Beberapa menhir menghadap gunung tertentu yang dianggap suci.',
    ),
    Artifact(
      name: 'Dolmen Bondowoso',
      summary: 'Meja batu raksasa yang dipakai sebagai altar atau penutup kubur.',
      significance: 'Pusat upacara pemujaan leluhur dalam tradisi megalitik.',
      latitude: -7.9,
      longitude: 113.83,
      era: 'Megalitikum',
      museum: 'Museum MPU Tantular',
      origin: 'Bondowoso, Jawa Timur',
      material: 'Batu andesit',
      period: '± 3.500 - 1.500 tahun lalu',
      ageYears: 3000,
      dimensions: 'Tinggi ± 1 m, meja ± 2 m',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Inventarisasi cagar budaya',
      thumbnail: 'assets/images/artifacts/dolmen.jpg',
      description:
          'Dolmen berupa meja batu: lempengan besar yang ditopang beberapa '
          'batu penyangga. Dalam tradisi megalitik, dolmen dipakai sebagai '
          'altar pemujaan atau penutup ruang kubur.',
      functionPast:
          'Tempat meletakkan sesaji dan menghormati arwah leluhur.',
      functionToday:
          'Situs cagar budaya dan penanda kepercayaan prasejarah.',
      discoveryInfo:
          'Tercatat dalam survei situs megalitik di Bondowoso.',
      characteristics:
          'Lempeng batu datar di atas penyangga\n'
          'Berbentuk seperti meja\n'
          'Sering berdekatan dengan menhir dan kubur batu',
      funFacts:
          'Kata dolmen berasal dari bahasa Breton, "meja batu".\n'
          'Dolmen ditemukan di banyak benua, dari Eropa hingga Asia.',
    ),
    Artifact(
      name: 'Sarkofagus Batu',
      summary: 'Peti jenazah dari satu batu utuh, lengkap dengan tutupnya.',
      significance: 'Menandakan masyarakat sudah bertingkat: hanya tokoh terhormat yang dimakamkan dengan cara ini.',
      latitude: -7.89,
      longitude: 113.85,
      era: 'Megalitikum',
      museum: 'Museum Anjuk Ladang',
      origin: 'Jawa Timur (tradisi kubur batu)',
      material: 'Batu andesit / batu kapur',
      period: '± 2.500 - 1.500 tahun lalu',
      ageYears: 2000,
      dimensions: 'Panjang ± 2 m',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/sarkofagus.jpg',
      description:
          'Peti jenazah dari batu utuh berbentuk palung dengan tutup. Di '
          'dalamnya kadang ditemukan rangka dengan bekal kubur seperti '
          'gerabah, manik-manik, atau benda logam. Penguburan seperti ini '
          'hanya untuk tokoh yang dihormati.',
      functionPast:
          'Wadah kubur bagi tokoh masyarakat, dilengkapi bekal untuk '
          'kehidupan sesudah mati.',
      functionToday:
          'Sumber informasi kepercayaan, struktur sosial, dan perdagangan '
          'masa lalu.',
      discoveryInfo:
          'Ditemukan oleh tim purbakala dan balai pelestarian cagar budaya.',
      characteristics:
          'Dua bagian: wadah dan tutup\n'
          'Dipahat dari satu batu besar\n'
          'Sering berisi bekal kubur',
      funFacts:
          'Satu sarkofagus bisa butuh berbulan-bulan untuk dipahat.\n'
          'Bentuk tutupnya kadang meniru atap rumah.',
    ),
    Artifact(
      name: 'Arca Batu Megalitik',
      summary: 'Patung manusia sederhana sebagai perwujudan leluhur.',
      significance: 'Contoh seni patung asli Nusantara sebelum pengaruh Hindu-Buddha.',
      latitude: -7.61,
      longitude: 111.88,
      era: 'Megalitikum',
      museum: 'Museum Anjuk Ladang',
      origin: 'Nganjuk, Jawa Timur',
      material: 'Batu andesit',
      period: '± 3.000 - 1.500 tahun lalu',
      ageYears: 2500,
      dimensions: 'Tinggi ± 60 - 120 cm',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/arca_batu.jpg',
      description:
          'Arca sederhana berwujud manusia dengan bentuk sangat distilir: '
          'kepala bulat, mata dan mulut dipahat tipis, tubuh kotak. '
          'Mewakili leluhur atau tokoh yang dipuja, sebelum datang '
          'pengaruh Hindu-Buddha.',
      functionPast:
          'Objek pemujaan roh leluhur dan penjaga komunitas.',
      functionToday:
          'Memperlihatkan seni patung asli Nusantara sebelum masa '
          'Hindu-Buddha.',
      discoveryInfo:
          'Ditemukan di kawasan situs Anjuk Ladang dan sekitarnya.',
      characteristics:
          'Bentuk manusia sangat sederhana\n'
          'Kepala besar, tubuh kaku\n'
          'Wajah dipahat minimalis',
      funFacts:
          'Gaya sederhana ini muncul sebelum arca Hindu-Buddha yang punya atribut dewa.\n'
          'Wajahnya sengaja dibuat minimalis, bukan potret seseorang.',
    ),
    Artifact(
      name: 'Batu Dakon',
      summary: 'Batu berlubang-lubang yang mirip papan congklak.',
      significance: 'Fungsi aslinya masih diperdebatkan, sehingga menjadi misteri menarik bagi arkeolog.',
      era: 'Megalitikum',
      museum: 'Museum Brawijaya',
      origin: 'Situs megalitik Jawa Timur',
      material: 'Batu andesit',
      period: '± 3.000 - 1.500 tahun lalu',
      ageYears: 2500,
      dimensions: 'Panjang ± 80 - 150 cm',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/dakon.jpg',
      description:
          'Batu datar dengan deretan lubang bulat di permukaannya, mirip '
          'papan permainan congklak (dakon). Para ahli menduga batu ini '
          'dipakai dalam upacara, bukan sekadar permainan.',
      functionPast:
          'Diduga untuk ritual, tempat sesaji atau kegiatan kalender '
          'pertanian.',
      functionToday:
          'Misteri menarik yang terus dikaji; namanya diambil dari permainan '
          'tradisional.',
      discoveryInfo:
          'Tercatat di sejumlah situs megalitik di Jawa.',
      characteristics:
          'Lubang berderet di permukaan batu\n'
          'Berbentuk papan\n'
          'Lubang dibuat dengan pengerjaan teliti',
      funFacts:
          'Fungsi aslinya masih diperdebatkan para arkeolog.\n'
          'Namanya meminjam permainan dakon (congklak) karena rupa lubangnya.',
    ),

    // ------------------------------------------------------------------
    // ZAMAN LOGAM
    // ------------------------------------------------------------------
    Artifact(
      name: 'Kapak Corong Perunggu',
      summary: 'Kapak perunggu dengan rongga di pangkal untuk memasang tangkai.',
      significance: 'Bukti masuknya teknologi logam ke Nusantara lewat jaringan dagang Asia Tenggara.',
      latitude: -7.47,
      longitude: 112.43,
      era: 'Zaman Logam',
      museum: 'Museum MPU Tantular',
      origin: 'Mojokerto & sekitarnya, Jawa Timur',
      material: 'Perunggu (tembaga + timah)',
      period: '± 2.500 - 1.800 tahun lalu',
      ageYears: 2300,
      dimensions: '± 15 - 25 cm',
      culture: 'Budaya perunggu Asia Tenggara (pengaruh Dongson)',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/kapak_corong.jpg',
      description:
          'Kapak perunggu dengan rongga berbentuk corong di pangkalnya untuk '
          'memasang tangkai kayu. Bentuknya mirip sepatu sehingga juga '
          'disebut kapak sepatu. Dicetak dari logam cair ke dalam cetakan.',
      functionPast:
          'Perkakas, senjata, dan benda upacara yang menunjukkan status '
          'pemiliknya.',
      functionToday:
          'Bukti masuknya teknologi logam ke Nusantara dan ikon koleksi '
          'Zaman Logam.',
      discoveryInfo:
          'Ditemukan di sejumlah lokasi di Jawa Timur oleh penduduk '
          'dan tim purbakala.',
      characteristics:
          'Pangkal berongga seperti corong\n'
          'Dicetak dengan cetakan (setangkup atau lilin hilang)\n'
          'Sering berhias pola garis dan geometris',
      funFacts:
          'Perunggu adalah campuran tembaga dan timah.\n'
          'Pengrajin perunggu kala itu adalah orang yang sangat dihormati.',
    ),
    Artifact(
      name: 'Nekara Perunggu',
      summary: 'Genderang perunggu besar untuk upacara, pemanggil hujan, dan penanda status.',
      significance: 'Bukti jaringan budaya Dongson dan tingginya kemampuan pengecoran logam masa itu.',
      era: 'Zaman Logam',
      museum: 'Museum MPU Tantular',
      origin: 'Nusantara (tipe Heger I, pengaruh Dongson)',
      material: 'Perunggu',
      period: '± 2.300 - 1.500 tahun lalu',
      ageYears: 2300,
      dimensions: 'Diameter puluhan cm hingga lebih dari 1 m',
      culture: 'Budaya perunggu Dongson',
      discoveryYear: 'Berbagai temuan abad ke-19 - 20',
      thumbnail: 'assets/images/artifacts/nekara.jpg',
      description:
          'Nekara adalah genderang perunggu berbentuk seperti dispenser: '
          'bidang pukul melebar di atas, badan menyempit, dan kaki '
          'melebar di bawah. Permukaannya dipenuhi hiasan bintang, garis, '
          'burung, dan perahu.',
      functionPast:
          'Genderang upacara pemanggil hujan, penanda status, dan bekal '
          'kubur tokoh penting.',
      functionToday:
          'Bukti jaringan perdagangan dan budaya Asia Tenggara Zaman Logam.',
      discoveryInfo:
          'Nekara ditemukan di banyak wilayah Nusantara; koleksi ini '
          'mewakili tipe Heger I.',
      characteristics:
          'Bidang pukul datar dengan pola bintang\n'
          'Badan menyempit di tengah\n'
          'Hiasan geometris dan binatang',
      funFacts:
          'Dipukul dalam upacara memanggil hujan.\n'
          'Nekara sering disebut sebagai "genderang bulan" karena bidang pukulnya bulat.',
    ),
    Artifact(
      name: 'Manik-manik Kuno',
      summary: 'Untaian manik batu dan kaca sebagai penghias tubuh.',
      significance: 'Jejak jalur dagang laut yang menghubungkan Nusantara dengan India.',
      era: 'Zaman Logam',
      museum: 'Museum Brawijaya',
      origin: 'Situs kubur prasejarah Jawa Timur',
      material: 'Batu akik, karnelian, kaca',
      period: '± 2.500 - 1.500 tahun lalu',
      ageYears: 2200,
      dimensions: 'Diameter ± 0,5 - 2 cm',
      culture: 'Budaya perunggu - besi Asia Tenggara',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/manik.jpg',
      description:
          'Untaian manik berwarna merah, kuning, biru, dan putih. Sebagian '
          'dari batu akik dan karnelian yang diasah, sebagian dari kaca '
          'yang datang lewat perdagangan jarak jauh. Manik sering '
          'ditemukan di dalam kubur.',
      functionPast:
          'Perhiasan, penanda status, dan bekal kubur.',
      functionToday:
          'Jejak jalur dagang laut kuno yang menghubungkan Nusantara dengan '
          'India dan sekitarnya.',
      discoveryInfo:
          'Ditemukan dalam penggalian kubur-kubur prasejarah di '
          'Jawa Timur.',
      characteristics:
          'Berlubang di tengah untuk dirangkai\n'
          'Warna cerah dan mengkilap\n'
          'Sebagian berupa kaca impor',
      funFacts:
          'Manik kaca bisa berasal dari India.\n'
          'Manik adalah salah satu barang dagangan tertua di dunia.',
    ),

    // ------------------------------------------------------------------
    // TAMBAHAN
    // ------------------------------------------------------------------
    Artifact(
      name: 'Geraham Trinil',
      summary: 'Gigi geraham terfosilkan yang menjadi temuan pertama Dubois di Trinil.',
      significance: 'Dari gigi inilah penggalian Trinil dimulai; tak lama kemudian ditemukan atap tengkorak yang mengubah ilmu evolusi manusia.',
      latitude: -7.376,
      longitude: 111.426,
      era: 'Palaeolitikum',
      museum: 'Museum Trinil',
      origin: 'Trinil, Ngawi, Jawa Timur',
      material: 'Gigi terfosilkan',
      period: '± 540.000 - 430.000 tahun lalu',
      ageYears: 500000,
      dimensions: '± 2 - 3 cm',
      culture: 'Homo erectus',
      discoveryYear: '1891',
      thumbnail: 'assets/images/artifacts/geraham.jpg',
      description:
          'Geraham besar terfosilkan dengan mahkota bertonjol dan dua akar. '
          'Gigi ini ditemukan di endapan tepi Bengawan Solo pada 1891 dan '
          'membuat Dubois melanjutkan penggalian; tak lama kemudian timnya '
          'menemukan atap tengkorak Homo erectus.',
      functionPast:
          'Mengunyah makanan: geraham besar menggiling tumbuhan dan daging.',
      functionToday:
          'Bukti kecil namun penting yang memulai penelitian manusia purba '
          'di Trinil.',
      discoveryInfo:
          'Ditemukan pada 1891 oleh tim Eugene Dubois di tepi Bengawan Solo, '
          'Trinil.',
      characteristics:
          'Mahkota lebar dengan beberapa tonjolan (cusp)\n'
          'Akar ganda yang kuat\n'
          'Enamel aus karena pemakaian\n'
          'Warna kecoklatan akibat fosilisasi',
      funFacts:
          'Gigi sering menjadi fosil karena enamelnya sangat keras.\n'
          'Gigi dan rahang membantu ahli mengetahui makanan dan usia '
          'sebuah makhluk.',
    ),
    Artifact(
      name: 'Gelang Perunggu',
      summary: 'Perhiasan lingkar dari perunggu cor dengan hiasan rusuk di permukaannya.',
      significance: 'Menunjukkan kemampuan mencetak logam sekaligus selera estetika dan status pemakainya.',
      era: 'Zaman Logam',
      museum: 'Museum Brawijaya',
      origin: 'Situs kubur Zaman Logam, Jawa Timur',
      material: 'Perunggu',
      period: '± 2.500 - 1.500 tahun lalu',
      ageYears: 2100,
      dimensions: 'Diameter ± 6 - 8 cm',
      culture: 'Budaya perunggu - besi Asia Tenggara',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/gelang_perunggu.jpg',
      description:
          'Gelang perunggu berbentuk cincin terbuka dengan rusuk-rusuk halus '
          'melingkar. Dibuat dengan menuang logam cair ke cetakan lalu '
          'dirapikan. Gelang seperti ini sering ditemukan sebagai bekal kubur.',
      functionPast:
          'Perhiasan dan penanda status; sebagian dikubur bersama pemiliknya.',
      functionToday:
          'Sumber informasi tentang teknik pengecoran dan hubungan dagang.',
      discoveryInfo:
          'Ditemukan dalam penggalian kubur-kubur Zaman Logam di Jawa Timur.',
      characteristics:
          'Bentuk cincin terbuka\n'
          'Rusuk atau garis hias melingkar\n'
          'Permukaan berpatina hijau karena usia',
      funFacts:
          'Warna hijau pada logam tua adalah karat khas perunggu (patina).\n'
          'Celah di salah satu sisi memudahkan gelang dipasang di pergelangan.',
    ),
    Artifact(
      name: 'Mata Tombak Besi',
      summary: 'Mata tombak besi berbentuk daun dengan lubang pangkal untuk tangkai kayu.',
      significance: 'Menandai dimulainya pemakaian besi, logam yang lebih keras dan lebih murah untuk senjata dan alat.',
      era: 'Zaman Logam',
      museum: 'Museum MPU Tantular',
      origin: 'Situs Zaman Logam, Jawa Timur',
      material: 'Besi',
      period: '± 2.000 - 1.500 tahun lalu',
      ageYears: 1800,
      dimensions: 'Panjang ± 20 - 30 cm',
      culture: 'Budaya perunggu - besi Asia Tenggara',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/tombak_besi.jpg',
      description:
          'Mata tombak besi berbentuk daun dengan rusuk di tengah dan rongga '
          'di pangkal untuk memasang tangkai. Besi mudah berkarat, sehingga '
          'temuan seperti ini tergolong langka.',
      functionPast:
          'Senjata berburu dan berperang, juga lambang kekuasaan.',
      functionToday:
          'Bukti peralihan dari Zaman Perunggu menuju Zaman Besi.',
      discoveryInfo:
          'Ditemukan dalam penggalian situs Zaman Logam di Jawa Timur.',
      characteristics:
          'Bilah berbentuk daun\n'
          'Rusuk tebal di tengah\n'
          'Pangkal berongga untuk tangkai\n'
          'Permukaan berkarat kecoklatan',
      funFacts:
          'Besi berkarat dalam tanah lembap, jadi temuan utuh sangat jarang.\n'
          'Mengolah besi butuh api yang lebih panas daripada perunggu.',
    ),
    Artifact(
      name: 'Lumpang Batu',
      summary: 'Balok batu dengan cekungan besar di permukaan, seperti lesung raksasa.',
      significance: 'Menghubungkan kehidupan sehari-hari (menumbuk) dengan upacara dalam tradisi megalitik.',
      era: 'Megalitikum',
      museum: 'Museum Anjuk Ladang',
      origin: 'Situs megalitik Jawa Timur',
      material: 'Batu andesit',
      period: '± 3.000 - 1.500 tahun lalu',
      ageYears: 2400,
      dimensions: 'Tinggi ± 30 - 50 cm',
      culture: 'Tradisi Megalitik',
      discoveryYear: 'Abad ke-20',
      thumbnail: 'assets/images/artifacts/lumpang.jpg',
      description:
          'Lumpang batu berupa balok batu yang dilubangi di bagian atas '
          'sehingga membentuk cekungan bulat. Fungsinya diduga ganda: '
          'menumbuk biji-bijian dan menjadi tempat sesaji dalam upacara.',
      functionPast:
          'Menumbuk padi atau biji-bijian; diduga juga dipakai dalam ritual.',
      functionToday:
          'Objek kajian yang memperlihatkan kaitan antara pertanian dan '
          'kepercayaan.',
      discoveryInfo:
          'Tercatat dalam survei situs megalitik di Jawa Timur.',
      characteristics:
          'Balok batu besar\n'
          'Cekungan bulat di bagian atas\n'
          'Permukaan dalam halus karena dipakai',
      funFacts:
          'Alat serupa dari kayu (lesung) masih dipakai di sebagian desa.\n'
          'Membuat cekungannya memerlukan pengerjaan berhari-hari.',
    ),
  ];

  static const List<Museum> museums = [
    Museum(
      name: 'Museum MPU Tantular',
      city: 'Sidoarjo',
      address: 'Jl. Raya Buduran, Sidoarjo, Jawa Timur',
      openHours: 'Selasa - Minggu, 08.00 - 15.30 WIB',
      description:
          'Museum negeri terbesar di Jawa Timur yang menyimpan koleksi '
          'prasejarah, etnografi, arkeologi klasik, hingga numismatika. '
          'Ruang prasejarahnya menampilkan kapak genggam, beliung persegi, '
          'menhir, dan kapak corong perunggu.',
      image: 'assets/images/museums/mpu_tantular.jpg',
      established: '1933',
      phone: '(031) 8961114',
      latitude: -7.4456,
      longitude: 112.7184,
      highlights:
          'Koleksi prasejarah paling lengkap di Jawa Timur\n'
          'Kapak corong dan nekara perunggu\n'
          'Replika fosil manusia purba',
    ),
    Museum(
      name: 'Museum Trinil',
      city: 'Ngawi',
      address: 'Desa Kawu, Kec. Kedunggalar, Ngawi, Jawa Timur',
      openHours: 'Setiap hari, 08.00 - 16.00 WIB',
      description:
          'Museum situs yang berdiri di kawasan ekskavasi Trinil, tempat '
          'Eugene Dubois menemukan fosil Pithecanthropus erectus (1891). '
          'Menampilkan replika fosil manusia purba, fosil fauna, '
          'serta rekonstruksi lingkungan Pleistosen Bengawan Solo.',
      image: 'assets/images/museums/trinil.jpg',
      established: '1991',
      phone: '',
      latitude: -7.3761,
      longitude: 111.4253,
      highlights:
          'Replika tengkorak dan tulang paha Homo erectus\n'
          'Fosil fauna Pleistosen (Stegodon dan lainnya)\n'
          'Berada di lokasi penemuan sesungguhnya',
    ),
    Museum(
      name: 'Museum Anjuk Ladang',
      city: 'Nganjuk',
      address: 'Jl. Raya Anjuk Ladang, Berbek, Nganjuk, Jawa Timur',
      openHours: 'Selasa - Minggu, 08.00 - 15.00 WIB',
      description:
          'Museum yang berada di kompleks situs Anjuk Ladang, lokasi '
          'ditemukannya prasasti abad ke-10. Koleksinya mencakup gerabah '
          'prasejarah, sarkofagus batu, arca megalitik, serta peninggalan '
          'masa Kadiri.',
      image: 'assets/images/museums/anjuk_ladang.jpg',
      established: '2010',
      phone: '',
      latitude: -7.6089,
      longitude: 111.9058,
      highlights:
          'Gerabah dan sarkofagus batu\n'
          'Arca megalitik\n'
          'Prasasti dan peninggalan masa klasik',
    ),
    Museum(
      name: 'Museum Brawijaya',
      city: 'Malang',
      address: 'Jl. Besar Ijen No. 25A, Malang, Jawa Timur',
      openHours: 'Selasa - Minggu, 08.00 - 15.00 WIB',
      description:
          'Museum militer TNI AD yang juga memamerkan koleksi arkeologi '
          'dari berbagai situs di Jawa Timur, termasuk artefak batu, '
          'gerabah, manik-manik, dan benda-benda masa kerajaan.',
      image: 'assets/images/museums/brawijaya.jpg',
      established: '1968',
      phone: '(0341) 551655',
      latitude: -7.9666,
      longitude: 112.6326,
      highlights:
          'Pipisan, gelang batu, dan batu dakon\n'
          'Manik-manik kuno\n'
          'Sejarah militer Jawa Timur',
    ),
  ];
}
