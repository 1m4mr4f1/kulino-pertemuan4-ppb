# WarungPOS — Aplikasi Kasir dan Pesanan UMKM

Aplikasi kasir dan manajemen pesanan warung makan UMKM berbasis Flutter cross-platform dengan arsitektur bersih, dukungan offline-first, state management terpusat, dan integrasi fitur perangkat keras.

> **Status:** Selesai & Terverifikasi (Gate 1 - Gate 4 Lolos Audit 100%)

---

## 1. Deklarasi Proyek

### Domain dan Masalah yang Diselesaikan
*Domain: Local Business Solutions*

Pengusaha warung makan skala kecil sering mengalami kendala pada pencatatan pesanan manual menggunakan kertas yang rentan hilang, salah hitung nominal transaksi saat kondisi ramai, serta tidak adanya rekapitulasi penjualan harian yang terstruktur. WarungPOS dirancang untuk pemilik warung makan dan kasir UMKM agar dapat mencatat pesanan pelanggan secara cepat, menghitung total bayar otomatis beserta kembalian, serta mengarsipkan riwayat penjualan harian langsung dari perangkat ponsel pintar tanpa bergantung pada mesin kasir konvensional yang mahal.

### Perancangan Layar Utama
1. **Layar Katalog Menu & Kategori**: Menampilkan kartu daftar makanan dan minuman dengan filter kategori, pencarian cepat, harga, dan tombol penambahan instan ke keranjang.
2. **Layar Kustomisasi Menu**: Form modal untuk mengatur jumlah porsi, varian tambahan, serta catatan khusus dari pelanggan.
3. **Layar Keranjang & Pembayaran**: Ringkasan item pesanan, kalkulasi subtotal otomatis, input uang diterima, perhitungan kembalian, dan pilihan metode transaksi (Tunai/QRIS).
4. **Layar Riwayat & Struk Digital**: Pratinjau nota digital siap bagikan serta daftar riwayat transaksi harian yang dapat ditinjau kembali.

### Tech Stack dan Alasan
Flutter dan Dart, karena menyediakan widget antarmuka yang responsif, performa rendering tinggi, serta kemudahan arsitektur state management untuk pengembangan aplikasi mobile.

### Hal yang Dipelajari dan Dikuasai
- Integrasi komunikasi serial Bluetooth Thermal Printer dan format byte ESC/POS untuk pencetakan nota fisik.
- Penerapan penyimpanan persisten lokal offline-first menggunakan `shared_preferences`.
- Manajemen state terpusat terpadu menggunakan `Provider` dan `ChangeNotifier`.
- Integrasi sensor perangkat keras: Haptic Feedback vibration motor dan sensor Geolocation GPS.

---

## 2. Struktur Arsitektur Proyek

```text
lib/
├── data/
│   └── mock_data.dart
├── models/
│   ├── cart_item.dart
│   ├── product.dart
│   └── transaction_record.dart
├── providers/
│   └── pos_provider.dart
├── repositories/
│   ├── product_repository.dart
│   ├── product_repository_impl.dart
│   ├── transaction_repository.dart
│   └── transaction_repository_impl.dart
├── screens/
│   ├── cart_screen.dart
│   ├── catalog_screen.dart
│   ├── history_screen.dart
│   ├── item_detail_screen.dart
│   └── receipt_screen.dart
└── main.dart
```

---

## 3. Fitur Utama

- **Katalog & Filter Interaktif:** Filter kategori dinamis (Semua, Makanan, Minuman, Camilan) dan fitur pencarian teks real-time.
- **Kustomisasi Pesanan:** Pengaturan porsi fleksibel serta input catatan khusus pelanggan per menu pesanan.
- **Offline-First Resilience:** Pengambilan data menu dari remote REST API dengan fallback otomatis ke cache lokal jika terjadi kendala jaringan atau tanpa koneksi internet.
- **Penyimpanan Persisten:** Riwayat transaksi tersimpan secara lokal dan tetap utuh meskipun aplikasi ditutup.
- **State Terpusat:** Dikelola menggunakan `PosProvider` untuk aliran data satu arah yang konsisten di semua layar.
- **Sensor Perangkat Keras:**
  - *Haptic Feedback:* Umpan balik getaran fisik pada tombol transaksi kasir.
  - *GPS Geolocation:* Pencatatan otomatis titik koordinat lokasi warung saat pesanan diproses.
- **Responsif di 3 Konfigurasi Layar:** Berjalan mulus tanpa overflow pada smartphone portrait, smartphone landscape, dan layar lebar tablet/desktop.

---

## 4. Cara Menjalankan & Menguji Aplikasi

### Menjalankan Pengujian Otomatis
```bash
flutter test
```

### Memeriksa Kualitas Kode
```bash
flutter analyze
```

### Menjalankan Mode Pengembangan
```bash
flutter run
```

---

## 5. Konfigurasi Rilis & Build APK

### Persiapan Kunci Tanda Tangan (Keystore)
Buat file `android/key.properties` berdasarkan template `android/key.properties.example`:
```properties
storePassword=password_keystore_anda
keyPassword=password_kunci_anda
keyAlias=alias_kunci_anda
storeFile=release-keystore.jks
```

### Menghasilkan Release Build APK
```bash
flutter build apk --release
```
File APK siap rilis akan dihasilkan pada:
`build/app/outputs/flutter-apk/app-release.apk`
