# Capstone Project — Panduan Umum

Proyek **individual** yang dikembangkan bertahap sepanjang semester. Bobot total
**40%** dari nilai mata kuliah, dibagi ke empat gate. Acuan capaian:
`../../RPS PPB - 20251.md`.

## Prinsip

1. **Yang dinilai adalah repo, bukan laporan tentang repo.** Tidak ada dokumen
   penyerahan terpisah, tidak ada slide, tidak ada laporan bab. Kode yang Anda
   tulis sudah menjadi bukti; menulis ulang isinya dalam bentuk dokumen hanya
   menambah beban tanpa menambah capaian.
2. **Individual, termasuk progresnya.** Setiap mahasiswa membangun aplikasinya
   sendiri. Kolaborasi tetap ada, tetapi lewat peer review, bukan lewat
   pembagian kerja.
3. **Stack bebas.** Bahasa, framework, dan tools apa pun. Rubrik menilai hasil,
   bukan pilihan teknologi. Modul kuliah tetap mengajarkan Flutter, dan Flutter
   adalah pilihan paling mudah didukung, tetapi tidak diwajibkan.
4. **Topik berbeda dari StudyTracker.** Aplikasi di modul adalah contoh yang
   dibedah di kelas. Capstone menilai kemampuan memindahkan pemahaman itu ke
   masalah lain.
5. **AI dipakai secara terbuka.** Lihat bagian "Aturan AI" di bawah: yang
   dilarang adalah menyembunyikan, bukan memakai.

## Domain

Pilih satu (sesuai RPS):

- **Local Business Solutions** — pemesanan warung/restoran, marketplace lokal,
  booking layanan, manajemen inventaris
- **Educational Technology** — LMS, platform asesmen, pengelolaan konten
  belajar, alat produktivitas mahasiswa
- **Health & Wellness** — pelacak kesehatan pribadi, pendukung telemedisin,
  pelacak kebugaran/nutrisi, pendamping kesehatan mental

## Empat Gate

| Gate                           | Minggu | Fokus                                                                    | Sub-CPMK | Bobot                         |
| ------------------------------ | ------ | ------------------------------------------------------------------------ | -------- | ----------------------------- |
| Deklarasi                      | P04    | domain, masalah, sketsa layar                                            | —        | tidak dinilai, syarat ikut G1 |
| **G1 — Fondasi**               | P07    | UI utuh, navigasi, data lokal sementara, bertahan di 3 konfigurasi layar | 92.1     | 8%                            |
| **G2 — Data**                  | P10    | REST API, penyimpanan lokal, tetap berfungsi saat offline                | 53.2     | 10%                           |
| **G3 — Arsitektur & Kualitas** | P13    | state terpusat, test yang jalan, minimal dua fitur perangkat             | 92.2     | 12%                           |
| **G4 — Rilis**                 | P15    | profiling, signed build, dokumentasi                                     | 53.2     | 10%                           |

Gate berjarak tiga minggu supaya ada ruang mengerjakan, bukan sekadar menyetor.

## Bentuk Penyerahan (sama untuk keempat gate)

Tiga hal, tidak pernah berubah. Setelah G1 Anda tidak perlu membaca ulang
aturannya.

1. **Tag di repo**: `gate-1`, `gate-2`, `gate-3`, `gate-4`. Tag dibuat sebelum
   tenggat; commit sesudah tag tidak dinilai.
2. **Satu blok baru di `CHANGELOG.md`**, maksimal satu halaman, empat butir:
   - **Jadi** — apa yang sekarang berfungsi
   - **Macet** — apa yang dicoba tapi belum berhasil, dan dugaan penyebabnya
   - **Keputusan** — satu keputusan teknis yang diambil beserta alasannya, dan
     apa alternatif yang ditolak
   - **AI** — lihat "Aturan AI"
3. **Video demo 5 menit**, diunggah ke YouTube sebagai _unlisted_, tautannya
   ditaruh di blok CHANGELOG gate tersebut. Isinya: aplikasi berjalan di
   perangkat/emulator, satu alur utama dijalankan penuh, lalu narasi singkat
   satu keputusan teknis yang Anda ambil.

   **Kualitas produksi tidak dinilai sama sekali.** Rekaman layar dengan suara
   sudah cukup. Tidak perlu editing, intro, musik, atau subtitle. Video yang
   rapi tapi aplikasinya tidak jalan bernilai lebih rendah daripada rekaman
   seadanya yang aplikasinya jalan.

Selain ketiganya, ada **tanya jawab di kelas** pada sesi praktikum setelah
tenggat, sebanyak waktu yang tersedia. Pertanyaan diambil dari video dan commit
Anda sendiri. Siapa yang ditanya tidak diumumkan sebelumnya.

Butir "Macet" bukan formalitas. Gate yang jujur melaporkan kegagalan bernilai
lebih tinggi daripada gate yang mengaku semuanya lancar lalu tidak terbukti di
video.

Empat video ini juga menjadi rekam jejak yang bisa Anda pakai melamar kerja:
perkembangan satu aplikasi dari layar kosong sampai rilis, dinarasikan sendiri
oleh pembuatnya. Itu lebih meyakinkan daripada satu video final yang mengilap.

## Syarat Masuk Gate

Dipenuhi dulu, baru pekerjaannya dinilai:

- Ada commit di **minimal tiga minggu berbeda** sejak gate sebelumnya. Satu
  ledakan commit di H-1 tidak memenuhi syarat, berapa pun banyaknya.
- Kuis unlock modul minggu berjalan sudah lulus.
- Peer review untuk gate tersebut sudah dikirim, bila gate itu menuntutnya (G1
  dan G3).

## Rubrik

Empat dimensi yang sama sepanjang semester, dengan tuntutan yang naik. Anda bisa
melihat posisi Anda sendiri di matriks ini kapan saja.

| Dimensi              | G1                                       | G2                                                     | G3                                                      | G4                                               |
| -------------------- | ---------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------ |
| **Fungsionalitas**   | satu alur utama utuh dari layar ke layar | data nyata dari server, tetap berfungsi tanpa jaringan | minimal dua fitur perangkat terintegrasi                | siap dipasang orang lain dari file rilis         |
| **Arsitektur**       | tampilan terpisah dari data              | lapisan data punya kontrak sendiri                     | state terpusat, keputusan konsisten di seluruh aplikasi | struktur terdokumentasi dan bisa dijelaskan      |
| **Ketahanan**        | tidak crash pada penggunaan wajar        | error jaringan dan input tertangani, bukan ditelan     | ada test yang benar-benar dijalankan                    | tidak ada kebocoran kunci/rahasia di build rilis |
| **Akuntabilitas AI** | deklarasi lengkap                        | deklarasi + satu analisis                              | satu saran AI ditolak beserta alasannya                 | refleksi penutup                                 |

Tiap dimensi dinilai 4 tingkat: **belum (0) · sebagian (1) · memenuhi (2) ·
melampaui (3)**. Nilai gate = rata-rata empat dimensi.

Satu aturan yang berlaku di atas semua angka: **kalau Anda tidak bisa
menjelaskan kode Anda sendiri saat ditanya, dimensi Arsitektur dan Ketahanan
turun satu tingkat penuh.** Ini berlaku terlepas dari siapa atau apa yang
menulis kodenya. Gugup bukan masalah dan tidak dihitung; yang dinilai adalah
apakah Anda mengenali kode itu, bukan apakah Anda lancar berbicara.

## Deklarasi Proyek (P04)

Satu halaman, tidak dinilai, tapi syarat ikut G1. Isinya empat hal:

1. Domain dan masalah yang diselesaikan, satu paragraf. Untuk siapa, dan kenapa
   masalah itu nyata.
2. Tiga sampai lima layar utama, boleh sketsa tangan yang difoto.
3. Stack yang dipilih dan alasannya satu kalimat.
4. Satu hal yang Anda belum tahu caranya, dan rencana mencarinya.

Butir 4 yang paling berguna. Proposal yang semua bagiannya sudah dikuasai
penulisnya biasanya pertanda proyeknya terlalu kecil.

lakukan commit beberapa kali sesuai ketentuan ke repo ini (dengan nama commit yg
berbeda)

echo "# kulino-pertemuan4-ppb" >> README.md git init git add README.md git
commit -m "first commit" git branch -M main git remote add origin
git@github.com:1m4mr4f1/kulino-pertemuan4-ppb.git git push -u origin main

## Penilaian Lain yang Terkait

| Komponen                 | Bobot | Kaitan dengan capstone                                              |
| ------------------------ | ----- | ------------------------------------------------------------------- |
| Peer code review         | 5%    | dua siklus, menempel pada G1 dan G3                                 |
| AI Integration Portfolio | 5%    | dikumpulkan dari butir AI keempat CHANGELOG, tanpa dokumen tambahan |
| UTS                      | 15%   | live coding + demo progres capstone sampai G1                       |
| UAS                      | 20%   | video presentasi final + demo dan tanya jawab di kelas              |
