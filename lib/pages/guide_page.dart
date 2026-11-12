import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Panduan penggunaan lengkap: tiap fitur dijelaskan dengan langkah singkat,
/// ditambah pertanyaan yang sering muncul.
class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  static const List<_Topic> _topics = [
    _Topic(
      icon: Icons.explore_rounded,
      color: Color(0xFF8A5A3B),
      title: 'Menjelajahi artefak',
      steps: [
        'Buka tab Jelajah. Ketik nama, bahan, atau lokasi di kolom cari.',
        'Ketuk chip zaman (mis. Neolitikum) untuk menyaring.',
        'Ketuk ikon filter untuk menyaring berdasarkan bahan, museum, atau '
            'hanya favorit.',
        'Ketuk menu urutkan untuk mengatur dari yang tertua hingga termuda.',
      ],
    ),
    _Topic(
      icon: Icons.info_outline_rounded,
      color: Color(0xFF3F8A78),
      title: 'Membaca halaman detail',
      steps: [
        'Geser foto di bagian atas: tampak utama, detail permukaan, dan '
            'perbandingan skala. Ketuk foto untuk memperbesar.',
        'Kotak "Intinya" merangkum artefak dalam satu kalimat.',
        'Bagian "Mengapa penting?" menjelaskan nilai artefak bagi sejarah.',
        'Ketuk istilah bergaris di "Istilah di halaman ini" untuk artinya.',
        'Buka akordeon Ciri Khas, Fungsi, Kisah Penemuan, dan Fakta Menarik '
            'untuk penjelasan lebih dalam.',
      ],
    ),
    _Topic(
      icon: Icons.light_mode_rounded,
      color: Color(0xFFB8862F),
      title: 'Cahaya Interaktif',
      steps: [
        'Di halaman detail, ketuk kartu gelap "Periksa dengan Cahaya".',
        'Seret jari di atas gambar: cahaya datang dari arah jarimu.',
        'Perhatikan bayangan pada permukaan. Cekungan, bekas pangkasan, '
            'dan hiasan jadi terlihat lebih jelas.',
        'Arkeolog memakai cahaya miring seperti ini untuk membaca ukiran '
            'dan bekas pengerjaan pada benda kuno.',
      ],
    ),
    _Topic(
      icon: Icons.volume_up_rounded,
      color: Color(0xFF3F8A78),
      title: 'Mendengarkan penjelasan',
      steps: [
        'Di halaman detail, ketuk ikon speaker di atas foto.',
        'Aplikasi membacakan nama, intinya, deskripsi, dan arti penting '
            'artefak dengan suara bahasa Indonesia dari perangkatmu.',
        'Ketuk lagi untuk berhenti. Bila tidak ada suara, pastikan mesin '
            'Text-to-Speech Indonesia terpasang di pengaturan HP.',
      ],
    ),
    _Topic(
      icon: Icons.add_a_photo_rounded,
      color: Color(0xFFB8862F),
      title: 'Memasang foto asli',
      steps: [
        'Di halaman detail, ketuk ikon kamera di pojok kanan atas foto.',
        'Pilih Kamera atau Galeri. Foto langsung tampil paling depan.',
        'Untuk menghapus, buka lagi lembar yang sama lalu ketuk tanda X di '
            'foto.',
        'Foto tersimpan di perangkatmu, tidak dikirim ke mana pun.',
      ],
    ),
    _Topic(
      icon: Icons.map_rounded,
      color: Color(0xFF3F8A78),
      title: 'Peta Situs',
      steps: [
        'Buka tab Belajar lalu Peta Situs.',
        'Cubit untuk memperbesar dan seret untuk menggeser.',
        'Lingkaran bernomor adalah situs temuan (angkanya jumlah artefak). '
            'Ikon gedung adalah museum.',
        'Ketuk penanda untuk melihat isinya. Gunakan chip untuk menyaring '
            'zaman.',
      ],
    ),
    _Topic(
      icon: Icons.quiz_rounded,
      color: Color(0xFFA4513A),
      title: 'Kuis, Tebak Benda, dan Kartu Belajar',
      steps: [
        'Kuis: 10 soal acak. Setelah menjawab, penjelasan muncul. Skor 70% '
            'ke atas dianggap lulus.',
        'Tebak Benda: lihat foto lalu pilih nama yang benar. Setiap tiga '
            'soal ada level sulit yang hanya menampilkan foto detail.',
        'Kartu Belajar: ketuk kartu untuk membaliknya, lalu tandai Hafal '
            'atau Ulangi. Kartu yang diulang akan muncul lagi.',
      ],
    ),
    _Topic(
      icon: Icons.edit_note_rounded,
      color: Color(0xFF6B8A45),
      title: 'Catatan dan koleksi sendiri',
      steps: [
        'Di detail artefak, ketuk kartu "Catatan Saya" untuk menulis.',
        'Semua catatan terkumpul di Profil lalu Catatan Saya.',
        'Untuk menambah artefak baru: Profil lalu Koleksi Buatanku lalu '
            'Tambah Artefak. Kolom bertanda wajib harus diisi.',
      ],
    ),
  ];

  static const List<(String, String)> _faq = [
    (
      'Apakah butuh internet?',
      'Tidak. Semua data dan gambar sudah ada di dalam aplikasi.'
    ),
    (
      'Di mana data favorit dan catatan saya disimpan?',
      'Di penyimpanan aplikasi pada perangkatmu. Data hilang bila aplikasi '
          'dihapus atau memakai menu Hapus Data Saya.'
    ),
    (
      'Mengapa gambar artefak berupa ilustrasi?',
      'Ilustrasi dipakai sebagai gambar bawaan. Kamu bisa menggantinya '
          'dengan foto asli lewat ikon kamera di halaman detail.'
    ),
    (
      'Apakah lokasi di peta akurat?',
      'Lokasi bersifat perkiraan untuk tujuan belajar. Peta digambar '
          'sederhana dan bukan untuk navigasi.'
    ),
    (
      'Apakah jam buka museum selalu benar?',
      'Jam dapat berubah. Periksa langsung ke museum sebelum berkunjung.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Panduan Penggunaan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Text(
            'Ketuk topik untuk melihat langkah-langkahnya. Di banyak halaman '
            'juga ada tombol "?" yang menjelaskan fitur tersebut.',
            style: AppText.body(context, size: 14, color: p.muted),
          ),
          const SizedBox(height: 16),
          for (final t in _topics) ...[
            _TopicCard(topic: t),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          Text('Pertanyaan Umum', style: AppText.display(context, size: 19)),
          const SizedBox(height: 12),
          for (final f in _faq) ...[
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.$1,
                      style: AppText.body(context,
                          size: 14, weight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(f.$2,
                      style: AppText.body(context,
                          size: 13.5, height: 1.55, color: p.muted)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Topic {
  const _Topic({
    required this.icon,
    required this.color,
    required this.title,
    required this.steps,
  });

  final IconData icon;
  final Color color;
  final String title;
  final List<String> steps;
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});

  final _Topic topic;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: p.primary,
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: topic.color.op(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(topic.icon, color: topic.color, size: 21),
          ),
          title: Text(topic.title,
              style: AppText.body(context, size: 14.5, weight: FontWeight.w700)),
          children: [
            for (var i = 0; i < topic.steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: topic.color.op(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: topic.color)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(topic.steps[i],
                          style: AppText.body(context, size: 13.5, height: 1.5)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
