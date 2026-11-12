#!/usr/bin/env python3
"""
Menyiapkan foto asli untuk aplikasi Jejak Purba.

Apa yang dilakukan:
  1. Membaca semua foto (.jpg/.jpeg/.png/.webp) di folder masukan.
  2. Memotong latar polos (hitam/putih/abu) di sekeliling benda.
  3. Menaruh benda di kanvas 4:3 berukuran 1600x1200 dengan latar yang
     warnanya disesuaikan dari foto asli.
  4. Menyimpan sebagai JPEG ke folder keluaran, siap disalin ke
     assets/images/artifacts/.

Penamaan: gunakan nama berkas sesuai PANDUAN_FOTO.md, mis.
    kapak_pacitan.jpg      -> tampak utama
    kapak_pacitan_2.jpg    -> detail permukaan
    kapak_pacitan_3.jpg    -> foto ketiga (skala/sudut lain)

Pemakaian:
    pip install pillow numpy
    python tools/siapkan_foto.py  foto_mentah  hasil
    # lalu salin isi folder "hasil" ke assets/images/artifacts/
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter, ImageOps

OUT_W, OUT_H = 1600, 1200
EXTS = {'.jpg', '.jpeg', '.png', '.webp'}


def background_color(arr):
    """Warna latar = median piksel di keempat sudut."""
    h, w = arr.shape[:2]
    n = max(4, min(h, w) // 20)
    corners = np.concatenate([
        arr[:n, :n].reshape(-1, 3), arr[:n, -n:].reshape(-1, 3),
        arr[-n:, :n].reshape(-1, 3), arr[-n:, -n:].reshape(-1, 3),
    ])
    return np.median(corners, axis=0)


def crop_to_subject(img, threshold=38, pad=0.10):
    arr = np.asarray(img.convert('RGB')).astype(float)
    bg = background_color(arr)
    diff = np.sqrt(((arr - bg) ** 2).sum(axis=2))
    mask = diff > threshold
    if mask.sum() < 50:
        return img, bg
    ys, xs = np.where(mask)
    x0, x1, y0, y1 = xs.min(), xs.max(), ys.min(), ys.max()
    pw, ph = int((x1 - x0) * pad), int((y1 - y0) * pad)
    box = (max(0, x0 - pw), max(0, y0 - ph),
           min(img.width, x1 + pw), min(img.height, y1 + ph))
    return img.crop(box), bg


def fit_canvas(img, bg):
    img = ImageOps.exif_transpose(img).convert('RGB')
    cropped, bg = crop_to_subject(img)
    scale = min(OUT_W * 0.86 / cropped.width, OUT_H * 0.86 / cropped.height)
    new = cropped.resize((max(1, int(cropped.width * scale)),
                          max(1, int(cropped.height * scale))), Image.LANCZOS)
    canvas = Image.new('RGB', (OUT_W, OUT_H), tuple(int(c) for c in bg))
    canvas.paste(new, ((OUT_W - new.width) // 2, (OUT_H - new.height) // 2))
    return canvas.filter(ImageFilter.UnsharpMask(radius=1.2, percent=60))


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    src, dst = Path(sys.argv[1]), Path(sys.argv[2])
    dst.mkdir(parents=True, exist_ok=True)
    files = [f for f in sorted(src.iterdir()) if f.suffix.lower() in EXTS]
    if not files:
        print('Tidak ada foto di', src)
        sys.exit(1)
    for f in files:
        try:
            out = fit_canvas(Image.open(f), None)
            target = dst / (f.stem + '.jpg')
            out.save(target, 'JPEG', quality=88, optimize=True, progressive=True)
            print('OK  ', f.name, '->', target.name)
        except Exception as e:  # noqa: BLE001
            print('GAGAL', f.name, e)
    print('\nSelesai. Salin isi', dst, 'ke assets/images/artifacts/')


if __name__ == '__main__':
    main()
