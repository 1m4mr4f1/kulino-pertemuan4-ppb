# Changelog

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
