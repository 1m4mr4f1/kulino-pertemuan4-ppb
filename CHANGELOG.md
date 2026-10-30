# Changelog

## [Gate-2] — Data (P10)

**Tautan Video Demo:** [https://youtu.be/placeholder-gate2-warungpos](https://youtu.be/placeholder-gate2-warungpos)

### 1. Jadi
- Integrasi pengambilan data katalog menu secara daring melalui remote REST API endpoint menggunakan paket `http` dengan batasan timeout 4 detik.
- Mekanisme penyimpanan lokal persisten (offline caching) menggunakan `shared_preferences` untuk menyimpan katalog menu dan riwayat transaksi.
- Aplikasi tetap berfungsi 100% tanpa jaringan internet (offline-ready); secara otomatis fallback ke cache lokal saat koneksi terputus atau gagal tanpa crash.
- Indikator status visual pada antarmuka pengguna (banner mode online vs mode offline) serta fitur Pull-to-Refresh / tombol sinkronisasi manual untuk memperbarui data dari server.
- Kontrak data abstraction yang jelas melalui antarmuka `ProductRepository` dan `TransactionRepository` yang terpisah dari detail implementasi.
- Seluruh riwayat transaksi kasir kini tersimpan secara permanen di storage perangkat dan dapat ditinjau atau dihapus kapan saja.

### 2. Macet
- Percobaan membuat sinkronisasi background worker otomatis dua arah saat perangkat beralih dari kondisi offline ke online belum berjalan stabil pada platform Linux desktop karena perbedaan implementasi plugin background execution platform interface. Dugaan penyebabnya adalah plugin background scheduler memerlukan service native Android (WorkManager) yang tidak tersedia di Linux desktop. Solusi sementara yang diterapkan adalah sinkronisasi on-demand via pull-to-refresh dan auto-retry pada saat aplikasi dimuat.

### 3. Keputusan
- Memilih strategi caching Cache-First with Network Refresh Fallback pada `ProductRepositoryImpl` serta memisahkan kontrak antarmuka repositori (`ProductRepository` dan `TransactionRepository`). Alternatif yang ditolak adalah Network-Only (yang menyebabkan aplikasi macet saat tidak ada sinyal) dan pemanggilan HTTP langsung di dalam method `StatefulWidget` (yang menyulitkan pengujian unit dan melanggar prinsip Single Responsibility).

### 4. AI
- Deklarasi Penggunaan AI: AI digunakan untuk merancang kontrak abstraksi data layer (Repository pattern), memformulasikan mekanisme penanganan error jaringan (`SocketException`, `TimeoutException`) secara terstruktur tanpa menelan exception mentah-mentah, serta menyusun skema serialisasi model JSON.
- Analisis AI: AI sempat menyarankan penggunaan SQLite (`sqflite`) yang membutuhkan binding native C library untuk setiap platform. Setelah dianalisis, arsitektur data WarungPOS pada tahap ini berorientasi pada payload key-value dokumen JSON yang berukuran ringan. Penggunaan `shared_preferences` jauh lebih portabel di semua target platform (Android, iOS, Web, Linux Desktop) tanpa risiko kegagalan build native library driver SQLite, sekaligus mencukupi seluruh kebutuhan offline storage aplikasi.

## [Gate-1] — Fondasi (P07)

**Tautan Video Demo:** [https://youtu.be/placeholder-gate1-warungpos](https://youtu.be/placeholder-gate1-warungpos)

### 1. Jadi
- Alur pemesanan lengkap dari katalog, pencarian menu, dan filter kategori (Makanan, Minuman, Camilan).
- Layar detail kustomisasi porsi dan catatan khusus pelanggan per menu.
- Manajemen keranjang belanja dengan kalkulasi otomatis subtotal, modifikasi kuantitas, dan opsi hapus item.
- Modul transaksi kasir dengan opsi metode pembayaran Tunai (kalkulasi uang diterima, quick chips pecahan uang, perhitungan kembalian otomatis) dan QRIS.
- Penerbitan struk transaksi digital terstruktur dan pencatatan riwayat transaksi lokal.
- Tata letak responsif adaptif yang teruji tidak mengalami overflow pada 3 konfigurasi layar: smartphone portrait, smartphone landscape, serta tablet/layar lebar (split-view keranjang).

### 2. Macet
- Percobaan integrasi pengiriman byte cetak langsung ke Bluetooth Thermal Printer belum dapat dijalankan pada tahap ini. Dugaan penyebabnya adalah keterbatasan ketersediaan unit printer thermal fisik saat pengetesan dan perlunya pairing serial Bluetooth RFCOMM langsung pada perangkat fisik nyata. Fitur ini direncanakan untuk diintegrasikan secara penuh pada Gate 3.

### 3. Keputusan
- Memisahkan secara ketat lapisan data model (`models/`), repositori data lokal (`data/`), dan tampilan antarmuka (`screens/`), daripada menyatukan semua kode ke dalam satu file tunggal. Keputusan ini diambil agar kode modular, mudah diuji (`flutter test`), dan siap ditingkatkan ke state management terpusat pada Gate selanjutnya.

### 4. AI
- AI dimanfaatkan untuk merancang struktur folder arsitektur bersih, menyusun skema relasi transaksi warung makan UMKM, menyusun layout adaptif GridView dan split-view, serta membuat pengujian widget. Semua kode yang dihasilkan dipahami secara mandiri, diverifikasi tanpa issue melalui `flutter analyze` dan `flutter test`.
