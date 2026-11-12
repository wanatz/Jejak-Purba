# Panduan Mengganti Gambar dengan Foto Asli

Gambar bawaan aplikasi adalah ilustrasi buatan. Foto asli membuat aplikasi jauh
lebih meyakinkan. Ada dua cara memasangnya.

## Cara 1 — Dari dalam aplikasi (paling mudah)
1. Buka detail artefak, ketuk ikon kamera di pojok kanan atas foto.
2. Pilih **Kamera** atau **Galeri**. Foto tampil paling depan di galeri.
3. Foto tersimpan di HP, tidak dikirim ke mana pun.

## Cara 2 — Mengganti gambar bawaan (untuk semua pengguna)
1. Kumpulkan foto sesuai tabel di bawah. Beri nama berkas sesuai kolom pertama.
   - `nama.jpg` = tampak utama, `nama_2.jpg` = detail permukaan, `nama_3.jpg` = sudut/skala.
   - Satu foto saja juga boleh; berkas yang tidak diganti tetap memakai ilustrasi.
2. Rapikan otomatis:
   ```
   pip install pillow numpy
   python tools/siapkan_foto.py  foto_mentah  hasil
   ```
3. Salin isi folder `hasil` ke `assets/images/artifacts/` (timpa berkas lama).
4. Jalankan ulang aplikasi (`flutter run`).

## Tips mencari foto
- Foto dari museum: minta izin tertulis atau foto sendiri saat berkunjung.
- Wikimedia Commons / situs museum: gunakan kata kunci pada kolom kanan, lalu
  **periksa lisensi** (mis. CC BY / CC BY-SA mewajibkan mencantumkan nama pemotret).
  Jangan memakai foto yang tidak jelas lisensinya.
- Latar polos (hitam atau putih) paling mudah dirapikan oleh skrip.
- Foto dari koleksi luar Jawa Timur (mis. kapak genggam dari Eropa/Afrika) boleh
  dipakai sebagai ilustrasi jenis alat, tetapi beri keterangan yang jujur dan
  jangan menyebutnya temuan Jawa Timur.

## Daftar berkas

| Berkas | Artefak di aplikasi | Foto yang dicari |
|---|---|---|
| `kapak_genggam.jpg`, `kapak_genggam_2.jpg`, `kapak_genggam_3.jpg` | Kapak Genggam Trinil | Kapak genggam batu (handaxe / chopper) Palaeolitik |
| `kapak_pacitan.jpg`, `kapak_pacitan_2.jpg`, `kapak_pacitan_3.jpg` | Kapak Genggam Pacitan | Kapak perimbas / chopper Pacitan, Pacitanian |
| `flake.jpg`, `flake_2.jpg`, `flake_3.jpg` | Alat Serpih Batu (Flake Tool) | Alat serpih (flake tool) batu |
| `fosil.jpg`, `fosil_2.jpg`, `fosil_3.jpg` | Fosil Tengkorak Pithecanthropus erectus | Replika tengkorak Trinil 2 (Homo erectus) |
| `femur.jpg`, `femur_2.jpg`, `femur_3.jpg` | Tulang Paha Trinil (Femur) | Femur Trinil / tulang paha Homo erectus |
| `stegodon.jpg`, `stegodon_2.jpg`, `stegodon_3.jpg` | Gading Stegodon | Gading atau tulang Stegodon fosil |
| `wajak.jpg`, `wajak_2.jpg`, `wajak_3.jpg` | Fosil Manusia Wajak | Replika tengkorak Wajak (Homo wajakensis) |
| `kapak_genggam.jpg`, `kapak_genggam_2.jpg`, `kapak_genggam_3.jpg` | Kapak Genggam Batu Anjuk Ladang | Kapak genggam batu (handaxe / chopper) Palaeolitik |
| `mikrolit.jpg`, `mikrolit_2.jpg`, `mikrolit_3.jpg` | Mikrolit Mata Panah | Mikrolit / microlith / mata panah mini batu |
| `tulang.jpg`, `tulang_2.jpg`, `tulang_3.jpg` | Alat Tulang Sampung | Alat tulang Sampung (bone tool) |
| `pipisan.jpg`, `pipisan_2.jpg`, `pipisan_3.jpg` | Pipisan dan Batu Giling | Pipisan dan batu giling (grinding stone) |
| `kapak_persegi.jpg`, `kapak_persegi_2.jpg`, `kapak_persegi_3.jpg` | Kapak Persegi (Beliung Persegi) | Beliung persegi / kapak persegi neolitik |
| `gerabah.jpg`, `gerabah_2.jpg`, `gerabah_3.jpg` | Gerabah Prasejarah Anjuk Ladang | Gerabah prasejarah bertepi terbuka |
| `gelang.jpg`, `gelang_2.jpg`, `gelang_3.jpg` | Gelang Batu Neolitik | Gelang batu neolitik (stone bracelet) |
| `menhir.jpg`, `menhir_2.jpg`, `menhir_3.jpg` | Menhir Bondowoso | Menhir (batu tegak) megalitik |
| `dolmen.jpg`, `dolmen_2.jpg`, `dolmen_3.jpg` | Dolmen Bondowoso | Dolmen (meja batu) megalitik |
| `sarkofagus.jpg`, `sarkofagus_2.jpg`, `sarkofagus_3.jpg` | Sarkofagus Batu | Sarkofagus batu, wadah dan tutup |
| `arca_batu.jpg`, `arca_batu_2.jpg`, `arca_batu_3.jpg` | Arca Batu Megalitik | Arca batu megalitik sederhana |
| `dakon.jpg`, `dakon_2.jpg`, `dakon_3.jpg` | Batu Dakon | Batu dakon / lumpang batu berlubang |
| `kapak_corong.jpg`, `kapak_corong_2.jpg`, `kapak_corong_3.jpg` | Kapak Corong Perunggu | Kapak corong / kapak sepatu perunggu |
| `nekara.jpg`, `nekara_2.jpg`, `nekara_3.jpg` | Nekara Perunggu | Nekara perunggu (bronze drum) |
| `manik.jpg`, `manik_2.jpg`, `manik_3.jpg` | Manik-manik Kuno | Manik-manik kuno (carnelian, kaca) |
| `geraham.jpg`, `geraham_2.jpg`, `geraham_3.jpg` | Geraham Trinil | Gigi geraham fosil Homo erectus (Trinil 1) |
| `gelang_perunggu.jpg`, `gelang_perunggu_2.jpg`, `gelang_perunggu_3.jpg` | Gelang Perunggu | Gelang perunggu Zaman Logam |
| `tombak_besi.jpg`, `tombak_besi_2.jpg`, `tombak_besi_3.jpg` | Mata Tombak Besi | Mata tombak besi kuno |
| `lumpang.jpg`, `lumpang_2.jpg`, `lumpang_3.jpg` | Lumpang Batu | Lumpang batu / lesung batu megalitik |
