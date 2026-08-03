# Alphabet Catch! 🎈

Game edukasi anak untuk Android & iOS — tangkap gambar (buah/hewan) yang namanya
diawali huruf yang sedang aktif.

## Fitur

- 2 tema: **Buah-buahan** (21 item) dan **Hewan** (24 item)
- Layar pengenalan kosakata sebelum tiap ronde dimulai
- Objek dengan huruf target muncul lebih sering (60%) dibanding distraktor
- Target 5 tangkapan benar per ronde, kesulitan (kecepatan jatuh) meningkat tiap ronde
- Sistem nyawa (3 nyawa, berkurang saat salah tangkap)
- Setelah menang ronde: pilih **lanjut ronde lebih sulit** atau **selesai & ganti tema**
- Kontrol 1 jari (geser untuk menggerakkan keranjang) — cocok untuk anak kecil

## Struktur Project

```
lib/
  main.dart                  # Entry point
  models/game_item.dart      # Model data GameItem & GameCategory
  data/categories.dart       # Daftar buah & hewan
  theme/app_colors.dart      # Palet warna
  widgets/
    big_button.dart          # Tombol besar bergaya kartun
    game_panel.dart          # Panel overlay putih membulat
  screens/
    game_screen.dart         # State machine utama + gameplay loop
    start_screen.dart
    category_screen.dart
    vocab_screen.dart
    round_intro_screen.dart
    win_screen.dart
    game_over_screen.dart
    finished_screen.dart
```

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terpasang: https://docs.flutter.dev/get-started/install
2. Di folder project, jalankan:
   ```bash
   flutter pub get
   flutter run
   ```
3. Untuk build rilis:
   ```bash
   flutter build apk        # Android
   flutter build ios        # iOS (perlu Xcode & Mac)
   ```

## Menambah Kategori Baru

Tambahkan `GameCategory` baru di `lib/data/categories.dart`, lalu daftar itu otomatis
akan muncul sebagai pilihan tema di layar "Pilih Permainan" (`category_screen.dart`)
karena kartu kategori digenerate dari `kCategories`.

## Menambah Aset Gambar Asli (bukan emoji)

Saat ini objek digambarkan pakai emoji supaya ringan & tanpa aset tambahan.
Untuk mengganti dengan ilustrasi asli:

1. Tambahkan file gambar ke folder `assets/images/`.
2. Daftarkan folder tersebut di `pubspec.yaml` bagian `flutter: assets:`.
3. Tambahkan field `imagePath` di `GameItem` (model.dart), lalu ganti widget
   `Text(item.emoji, ...)` di `game_screen.dart` dan `vocab_screen.dart`
   menjadi `Image.asset(item.imagePath, ...)`.

## Ide Pengembangan Lanjutan

- Voice-over pengucapan huruf & nama benda (text-to-speech / audio file)
- Animasi karakter maskot, efek partikel saat menangkap
- Local storage untuk menyimpan skor tertinggi / progress belajar anak
- Mode tanpa iklan & kepatuhan kebijakan "Designed for Families" (Play Store) /
  App Store Kids Category
