# Jejak Purba v2.3 — Katalog Benda Prasejarah Jawa Timur

Aplikasi Flutter offline-first. Tanpa tiket/kunjungan: fokus pada benda kuno dan ceritanya.

## Fitur
**Jelajah & detail**
- Beranda: banner panorama, artefak pilihan harian, "Terakhir Dilihat", "Tahukah Kamu?", zaman, museum.
- Jelajah: cari, filter zaman, filter lanjutan (bahan, museum, favorit), urutkan, grid/daftar, tab museum.
- Detail artefak: galeri 3 foto (utama, detail permukaan, skala), ringkasan cepat, posisi linimasa,
  akordeon Ciri Khas / Fungsi / Penemuan / Fakta, lokasi di peta, catatan pribadi, bandingkan, artefak terkait.
- Detail museum: foto luar + ruang pamer, sorotan, alamat, jam buka, koordinat, koleksi.

**Fitur unggulan**
- **Cahaya Interaktif**: seret jari untuk menggeser arah cahaya dan melihat relief/bekas pangkasan (teknik arkeolog).
- **Dengarkan penjelasan**: narasi suara bahasa Indonesia (Text-to-Speech) di halaman detail.
- 25 artefak, 200 bingkai cahaya, animasi masuk, umpan balik getar.

**Penjelasan yang jelas**
- Kotak "Intinya" (satu kalimat) dan "Mengapa penting?" di setiap artefak.
- Istilah di halaman detail bisa diketuk untuk melihat artinya (dari Glosarium).
- Tombol bantuan "?" di Peta, Bandingkan, Kartu Belajar, Linimasa, Glosarium, Kuis, dan Tebak Benda.
- Halaman Panduan Penggunaan + pertanyaan umum (Profil -> Panduan Penggunaan).

**Gambar**
- Gambar bawaan dirender dengan model 3D berpencahayaan (relief, bayangan, kilap material) di latar studio gelap.
  Ini tetap ilustrasi, bukan foto sungguhan; ganti dengan foto asli lewat langkah di bawah.

**Foto asli**
- Detail artefak -> ikon kamera: ambil foto atau pilih dari galeri; jadi sampul dan galeri terdepan.
- Tambah Artefak juga bisa memakai foto sendiri.
- Mengganti gambar bawaan: lihat `PANDUAN_FOTO.md` dan `tools/siapkan_foto.py`.

**Belajar**
- Peta Situs interaktif (zoom, penanda museum & situs temuan, filter zaman).
- Linimasa 5 zaman dengan ilustrasi, Kuis (40 soal, 10 acak), Tebak Benda (permainan foto),
  Kartu Belajar (flip card), Bandingkan dua artefak, Glosarium (30 istilah), Tokoh Peneliti.
- Pencapaian: 14 lencana. Catatan pribadi, favorit artefak & museum, koleksi buatan sendiri.
- Mode terang/gelap, ukuran teks (kecil sampai sangat besar), onboarding, SQLite dengan migrasi otomatis (v4).

## Menjalankan
```
flutter pub get
python tools/patch_android.py      # sekali saja, agar suara (TTS) jalan di Android 11+
dart run flutter_launcher_icons     # sekali saja, untuk ikon aplikasi
flutter run
```
Mengganti nama aplikasi: `AppInfo` di `lib/theme/app_theme.dart`.
Mengganti gambar: timpa file di `assets/images/` dengan nama yang sama (utama, `_2` detail, `_3` skala).
