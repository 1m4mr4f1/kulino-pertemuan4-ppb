# WarungPOS — Aplikasi Kasir dan Pesanan UMKM

Aplikasi kasir sederhana berbasis mobile untuk membantu efisiensi pencatatan transaksi dan pesanan warung makan UMKM.

## Deklarasi Proyek (Pertemuan 4)

### 1. Domain dan Masalah yang Diselesaikan
*Domain: Local Business Solutions*

Pengusaha warung makan skala kecil sering mengalami kendala pada pencatatan pesanan manual menggunakan kertas yang rentan hilang, salah hitung nominal transaksi saat kondisi ramai, serta tidak adanya rekapitulasi penjualan harian yang terstruktur. WarungPOS dirancang untuk pemilik warung makan dan kasir UMKM agar dapat mencatat pesanan pelanggan secara cepat, menghitung total bayar otomatis beserta kembalian, serta mengarsipkan riwayat penjualan harian langsung dari perangkat ponsel pintar tanpa bergantung pada mesin kasir konvensional yang mahal.

### 2. Perancangan Layar Utama
1. **Layar Katalog Menu & Kategori**: Menampilkan kartu daftar makanan dan minuman dengan filter kategori, pencarian cepat, harga, dan tombol penambahan instan ke keranjang.
2. **Layar Kustomisasi Menu**: Form modal untuk mengatur jumlah porsi, varian tambahan, serta catatan khusus dari pelanggan.
3. **Layar Keranjang & Pembayaran**: Ringkasan item pesanan, kalkulasi subtotal otomatis, input uang diterima, perhitungan kembalian, dan pilihan metode transaksi (Tunai/QRIS).
4. **Layar Riwayat & Struk Digital**: Pratinjau nota digital siap bagikan serta daftar riwayat transaksi harian yang dapat ditinjau kembali.

### 3. Tech Stack dan Alasan
Flutter dan Dart, karena menyediakan widget antarmuka yang responsif, performa rendering tinggi, serta kemudahan arsitektur state management untuk pengembangan aplikasi mobile.

### 4. Hal yang Belum Dikuasai dan Rencana Mempelajarinya
- **Tantangan Teknis**: Integrasi komunikasi perangkat keras Bluetooth Thermal Printer untuk mencetak struk pesanan secara nirkabel menggunakan format byte command ESC/POS.
- **Rencana Mempelajari**: Membaca dokumentasi paket `blue_thermal_printer` di pub.dev, menelaah referensi protokol perintah byte ESC/POS untuk pencetakan teks nota, serta bereksperimen menghubungkan perangkat dengan printer kasir portabel.
