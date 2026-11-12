import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/artifact.dart';
import '../providers/artifact_provider.dart';
import '../providers/category_provider.dart';
import '../providers/museum_provider.dart';
import '../services/photo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/artifact_card.dart';
import '../widgets/common.dart';

/// Formulir menambah artefak sendiri, lengkap dengan pratinjau langsung
/// dan pilihan ilustrasi bawaan.
class AddArtifactPage extends StatefulWidget {
  const AddArtifactPage({Key? key}) : super(key: key);

  @override
  State<AddArtifactPage> createState() => _AddArtifactPageState();
}

class _AddArtifactPageState extends State<AddArtifactPage> {
  static const List<String> _images = [
    'kapak_genggam',
    'kapak_pacitan',
    'flake',
    'fosil',
    'femur',
    'stegodon',
    'wajak',
    'mikrolit',
    'tulang',
    'pipisan',
    'kapak_persegi',
    'gerabah',
    'gelang',
    'menhir',
    'dolmen',
    'sarkofagus',
    'arca_batu',
    'dakon',
    'kapak_corong',
    'nekara',
    'manik',
    'geraham',
    'gelang_perunggu',
    'tombak_besi',
    'lumpang',
  ];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _summary = TextEditingController();
  final List<String> _photos = [];
  bool _saved = false;
  final _origin = TextEditingController();
  final _material = TextEditingController();
  final _period = TextEditingController();
  final _age = TextEditingController();
  final _dimensions = TextEditingController();
  final _culture = TextEditingController();
  final _year = TextEditingController();
  final _description = TextEditingController();
  final _past = TextEditingController();
  final _today = TextEditingController();
  final _discovery = TextEditingController();
  final _traits = TextEditingController();
  final _facts = TextEditingController();

  String _era = CategoryProvider.allCategories.first.name;
  String? _museum;
  String _image = 'kapak_genggam';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _origin.addListener(_refresh);
    _period.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    if (!_saved) {
      for (final path in _photos) {
        PhotoService.delete(path);
      }
    }
    for (final c in [
      _name,
      _summary,
      _origin,
      _material,
      _period,
      _age,
      _dimensions,
      _culture,
      _year,
      _description,
      _past,
      _today,
      _discovery,
      _traits,
      _facts,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v, {int min = 1, String label = 'Kolom ini'}) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return '$label wajib diisi';
    if (t.length < min) return '$label minimal $min karakter';
    return null;
  }

  Artifact _build() {
    return Artifact(
      name: _name.text.trim(),
      era: _era,
      museum: _museum ?? 'Koleksi Pribadi',
      origin: _origin.text.trim(),
      material: _material.text.trim(),
      period: _period.text.trim(),
      ageYears: int.tryParse(_age.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      dimensions: _dimensions.text.trim(),
      culture: _culture.text.trim(),
      discoveryYear: _year.text.trim(),
      thumbnail: 'assets/images/artifacts/$_image.jpg',
      description: _description.text.trim(),
      functionPast: _past.text.trim(),
      functionToday: _today.text.trim(),
      discoveryInfo: _discovery.text.trim(),
      characteristics: _traits.text.trim(),
      funFacts: _facts.text.trim(),
      summary: _summary.text.trim(),
      photos: List<String>.from(_photos),
      isCustom: true,
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final path = await PhotoService.pick(source);
    if (path != null && mounted) setState(() => _photos.add(path));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Lengkapi kolom yang bertanda merah')));
      return;
    }
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    _saved = true;
    await context.read<ArtifactProvider>().addArtifact(_build());
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Artefak ditambahkan')));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final museums = context.watch<MuseumProvider>().museums;
    final preview = _build().copyWith(
      name: _name.text.trim().isEmpty ? 'Nama artefak' : _name.text.trim(),
      origin: _origin.text.trim().isEmpty ? 'Asal temuan' : _origin.text.trim(),
      period: _period.text.trim().isEmpty ? 'Perkiraan usia' : _period.text.trim(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Artefak')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            Text('Pratinjau', style: AppText.display(context, size: 17)),
            const SizedBox(height: 10),
            ArtifactCard(artifact: preview, onTap: () {}),
            const SizedBox(height: 22),
            _Section('Foto Sendiri (opsional)'),
            Text(
              'Foto asli dari museum atau kameramu menjadi sampul artefak. '
              'Kalau dikosongkan, ilustrasi di bawah yang dipakai.',
              style: AppText.muted(context, size: 12.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickPhoto(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_rounded, size: 20),
                    label: const Text('Kamera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded, size: 20),
                    label: const Text('Galeri'),
                  ),
                ),
              ],
            ),
            if (_photos.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => Stack(
                    children: [
                      ArtImage(
                          path: _photos[i], width: 84, height: 84, radius: 14),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () {
                            PhotoService.delete(_photos[i]);
                            setState(() => _photos.removeAt(i));
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9534F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            _Section('Ilustrasi Bawaan'),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final name = _images[i];
                  final selected = name == _image;
                  return GestureDetector(
                    onTap: () => setState(() => _image = name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: selected ? p.primary : Colors.transparent,
                            width: 2.5),
                      ),
                      child: ArtImage(
                        path: 'assets/images/artifacts/$name.jpg',
                        width: 64,
                        height: 64,
                        radius: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            _Section('Identitas'),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: appInputDecoration(context,
                  label: 'Nama artefak', hint: 'mis. Kapak Genggam Ngawi'),
              validator: (v) => _required(v, min: 3, label: 'Nama'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _era,
              isExpanded: true,
              decoration: appInputDecoration(context, label: 'Zaman'),
              items: [
                for (final c in CategoryProvider.allCategories)
                  DropdownMenuItem<String>(
                      value: c.name, child: Text('${c.name}  ·  ${c.range}')),
              ],
              onChanged: (v) => setState(() => _era = v ?? _era),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _museum,
              isExpanded: true,
              decoration: appInputDecoration(context,
                  label: 'Museum / lokasi simpan', hint: 'Pilih museum'),
              items: [
                for (final m in museums)
                  DropdownMenuItem<String>(value: m.name, child: Text(m.name)),
                const DropdownMenuItem<String>(
                    value: 'Koleksi Pribadi', child: Text('Koleksi Pribadi')),
              ],
              onChanged: (v) => setState(() => _museum = v),
              validator: (v) => v == null ? 'Pilih salah satu' : null,
            ),
            const SizedBox(height: 22),
            _Section('Data Singkat'),
            TextFormField(
              controller: _origin,
              decoration: appInputDecoration(context,
                  label: 'Asal temuan', hint: 'mis. Pacitan, Jawa Timur'),
              validator: (v) => _required(v, label: 'Asal temuan'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _material,
              decoration: appInputDecoration(context,
                  label: 'Bahan', hint: 'mis. Batu rijang'),
              validator: (v) => _required(v, label: 'Bahan'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _period,
              decoration: appInputDecoration(context,
                  label: 'Perkiraan usia (teks)',
                  hint: 'mis. ± 4.000 - 2.500 tahun lalu'),
              validator: (v) => _required(v, label: 'Usia'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    decoration: appInputDecoration(context,
                        label: 'Usia (tahun)', hint: '4000'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _dimensions,
                    decoration: appInputDecoration(context,
                        label: 'Ukuran', hint: '± 12 cm'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _culture,
                    decoration: appInputDecoration(context, label: 'Budaya'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _year,
                    decoration:
                        appInputDecoration(context, label: 'Tahun temuan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _Section('Cerita'),
            TextFormField(
              controller: _summary,
              maxLines: 2,
              minLines: 1,
              decoration: appInputDecoration(context,
                  label: 'Intinya (satu kalimat)',
                  hint: 'Ringkasan singkat agar mudah dipahami'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              maxLines: 5,
              minLines: 3,
              decoration: appInputDecoration(context,
                  label: 'Deskripsi',
                  hint: 'Ceritakan bentuk dan ciri benda ini'),
              validator: (v) => _required(v, min: 20, label: 'Deskripsi'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _past,
              maxLines: 3,
              minLines: 2,
              decoration:
                  appInputDecoration(context, label: 'Fungsi pada masa lalu'),
              validator: (v) => _required(v, label: 'Fungsi masa lalu'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _today,
              maxLines: 3,
              minLines: 2,
              decoration:
                  appInputDecoration(context, label: 'Makna masa kini'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _discovery,
              maxLines: 3,
              minLines: 2,
              decoration:
                  appInputDecoration(context, label: 'Kisah penemuan'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _traits,
              maxLines: 4,
              minLines: 3,
              decoration: appInputDecoration(context,
                  label: 'Ciri khas', hint: 'Satu butir per baris'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _facts,
              maxLines: 4,
              minLines: 3,
              decoration: appInputDecoration(context,
                  label: 'Fakta menarik', hint: 'Satu butir per baris'),
            ),
            const SizedBox(height: 26),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check_rounded),
              label: Text(_saving ? 'Menyimpan...' : 'Simpan Artefak'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: AppText.display(context, size: 17)),
    );
  }
}
