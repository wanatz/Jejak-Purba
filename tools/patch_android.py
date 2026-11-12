#!/usr/bin/env python3
"""
Menambahkan izin 'queries' untuk mesin suara (TTS) ke AndroidManifest.xml
agar fitur "Dengarkan penjelasan" berjalan di Android 11 ke atas.

Pemakaian (dari folder proyek):
    python tools/patch_android.py
Aman dijalankan berulang kali.
"""
import sys
from pathlib import Path

PATH = Path(sys.argv[1] if len(sys.argv) > 1 else
            'android/app/src/main/AndroidManifest.xml')
BLOCK = """    <queries>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries>
"""

if not PATH.exists():
    sys.exit(f'Berkas tidak ditemukan: {PATH}. Jalankan dari folder proyek Flutter.')
text = PATH.read_text(encoding='utf-8')
if 'android.intent.action.TTS_SERVICE' in text:
    print('Sudah terpasang, tidak ada perubahan.')
elif '<queries>' in text:
    text = text.replace('<queries>', '<queries>\n        <intent>\n            <action android:name="android.intent.action.TTS_SERVICE" />\n        </intent>', 1)
    PATH.write_text(text, encoding='utf-8')
    print('Ditambahkan ke blok <queries> yang sudah ada.')
elif '<application' in text:
    text = text.replace('<application', BLOCK + '    <application', 1)
    PATH.write_text(text, encoding='utf-8')
    print('Berhasil menambahkan <queries> untuk TTS.')
else:
    sys.exit('Tag <application> tidak ditemukan; periksa manifest secara manual.')
