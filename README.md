# MyPortfolio Mobile

Aplikasi mobile Flutter untuk **portofolio pribadi**, pendamping website portofolio Django (repositori terpisah). Dikembangkan bertahap mengikuti Tutorial dan Individual Assignment mingguan mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI.

| | |
| --- | --- |
| **Nama** | Alisa Selvia Saharani |
| **NPM** | 2506618433 |
| **Kelas** | PBP D |

## Fitur

- **Halaman utama (`MyHomePage`, `StatelessWidget`)** dengan header sambutan dan tiga `InfoCard` berisi NPM, Name, dan Class.
- **Tiga tombol aksi (`ItemCard`)** dengan ikon dan warna latar berbeda, warna dibaca dari model `ItemHomepage.color` tanpa percabangan if-else:
  - Lihat Experience (biru).
  - Tambah Experience (hijau).
  - Logout (merah).
- **SnackBar** "Kamu telah menekan tombol [Nama Tombol]!" setiap tombol ditekan.
- **Tampilan responsif**: lebar konten dibatasi 600 sehingga tetap proporsional di Chrome/desktop maupun HP.
- **Widget test** untuk halaman utama dan SnackBar tiap tombol.

## Kebutuhan Instalasi

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable). Dart sudah termasuk.
- Git.
- Salah satu target untuk menjalankan aplikasi: Chrome (web), emulator Android, atau perangkat fisik.
- Editor, misalnya VS Code (ekstensi Flutter) atau Android Studio.

## Instruksi Setup

1. Clone repositori lalu masuk ke folder proyek (folder yang berisi `pubspec.yaml`):
   ```bash
   git clone <URL-REPOSITORI-ANDA>
   cd myportofolio_mobile
   ```
2. Pastikan lingkungan Flutter siap:
   ```bash
   flutter doctor
   ```
3. Unduh dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run -d chrome        # web
   flutter devices              # lihat daftar emulator/perangkat
   flutter run -d <id-perangkat>
   ```
5. Cek kualitas kode dan jalankan test:
   ```bash
   flutter analyze              # harapan: No issues found!
   flutter test
   ```

Tips saat aplikasi berjalan: `r` hot reload, `R` hot restart, `q` berhenti. Setelah mengubah `pubspec.yaml` atau menambah aset, hentikan aplikasi lalu jalankan `flutter run` lagi.

## Struktur Proyek

```
lib/
├── main.dart    # bootstrap: MyApp + MaterialApp
└── menu.dart    # MyHomePage, InfoCard, ItemCard, ItemHomepage
test/widget_test.dart   # widget test
```

## Alur Git

Pengembangan dilakukan per fitur pada branch terpisah, lalu di-merge ke `main`:

| Branch | Isi |
| --- | --- |
| `feat/colored-item-cards` | `ItemHomepage.color` dan `ItemCard` berwarna |
| `fix/home-layout-scroll` | perbaikan layout dan scroll halaman utama |
| `test/widget-smoke` | widget test halaman utama |

Tautan yang dikumpulkan adalah commit terakhir pada branch `main`.

## Progres Mingguan

| Minggu | Topik | Isi |
| --- | --- | --- |
| [Tutorial 08](https://pbp.cs.ui.ac.id/tutorial/tutorial-8.html) | Basic Flutter | Setup proyek, `menu.dart` dipisah dari `main.dart`, `InfoCard` dan `ItemCard` |
| [Tugas 7](https://pbp.cs.ui.ac.id/assignments/individual/tugas-7.html) | Basic Flutter | Identitas sendiri, 3 tombol berwarna unik, SnackBar, tampilan responsif, widget test |

### Tugas 7

**Pertanyaan Reflektif**

1. **Widget tree dan hubungan parent-child.**
   Widget tree adalah struktur pohon dari semua widget yang menyusun UI: setiap widget bersarang di dalam widget lain sehingga membentuk satu akar (root) dengan cabang-cabang di bawahnya. Pohon halaman utama proyek ini:

   ```
   MyApp (StatelessWidget)
   └── MaterialApp
       └── MyHomePage (StatelessWidget)
           └── Scaffold
               ├── AppBar → Text('MyPortfolio')
               └── body: SingleChildScrollView
                   └── Center → ConstrainedBox(maxWidth: 600)
                       └── Column
                           ├── Container (header gradasi) → Column → [Text, Text]
                           └── Padding → Column
                               ├── IntrinsicHeight → Row
                               │   ├── Expanded → InfoCard (NPM)
                               │   ├── Expanded → InfoCard (Name)
                               │   └── Expanded → InfoCard (Class)
                               │       └── Card → Padding → Column → [CircleAvatar, Text, Text]
                               ├── Text('Menu')
                               └── GridView.count
                                   ├── ItemCard (Lihat Experience, biru)
                                   ├── ItemCard (Tambah Experience, hijau)
                                   └── ItemCard (Logout, merah)
                                       └── Material → InkWell → Container → Center
                                           └── Column → [Icon, Padding, Text]
   ```

   Hubungan parent-child: parent adalah widget yang memuat widget lain (child). Satu anak memakai properti `child`, banyak anak memakai `children`. Parent mengirim *constraints* ke child, child menentukan ukurannya sendiri dalam batas itu, lalu parent menentukan posisinya. Contohnya `ConstrainedBox` membatasi lebar `Column` di bawahnya, dan `Expanded` membuat tiap `InfoCard` mendapat sepertiga lebar `Row`. Data seperti `Theme` mengalir turun dari `MaterialApp` ke semua keturunannya. Saat state berubah, Flutter hanya membangun ulang (rebuild) bagian pohon yang terdampak.

2. **Widget yang dipakai dan fungsinya.**

   | No | Widget | Fungsi |
   | --- | --- | --- |
   | 1 | `MyApp` | Widget root buatan sendiri (`StatelessWidget`) yang membangun `MaterialApp`. |
   | 2 | `MaterialApp` | Root aplikasi: menyediakan tema Material, navigasi (`Navigator`), halaman awal (`home`), dan `ScaffoldMessenger`. |
   | 3 | `MyHomePage` | Halaman utama buatan sendiri (`StatelessWidget`) di `lib/menu.dart`. |
   | 4 | `Scaffold` | Kerangka halaman: `appBar`, `body`, dan tempat SnackBar muncul. |
   | 5 | `AppBar` | Bar judul di bagian atas halaman. |
   | 6 | `Text` | Menampilkan teks (judul, isi kartu, nama tombol). |
   | 7 | `Padding`, `SizedBox` | Memberi jarak/ruang kosong dan ukuran tetap antar widget. |
   | 8 | `Center` | Memusatkan child di ruang yang tersedia. |
   | 9 | `Container` | Wadah serbaguna untuk warna, padding, ukuran, dan dekorasi (`BoxDecoration`, `LinearGradient`). |
   | 10 | `ConstrainedBox` | Membatasi lebar maksimum konten (600) agar proporsional di layar lebar. |
   | 11 | `Column`, `Row` | Menyusun anak secara vertikal (`Column`) dan horizontal (`Row`). |
   | 12 | `Expanded` | Membagi lebar `Row` sama rata untuk tiga `InfoCard`. |
   | 13 | `IntrinsicHeight` | Menyamakan tinggi ketiga `InfoCard` dalam satu baris. |
   | 14 | `SingleChildScrollView` | Membuat halaman utama bisa di-scroll agar tidak overflow di layar kecil. |
   | 15 | `GridView.count` | Menampilkan `ItemCard` dalam kisi 3 kolom. |
   | 16 | `InfoCard` | Widget buatan sendiri: kartu informasi (ikon, judul, isi) untuk NPM, Name, dan Class. |
   | 17 | `Card` + `RoundedRectangleBorder` | Kartu bersudut membulat dan berbayangan untuk `InfoCard`. |
   | 18 | `CircleAvatar`, `Icon` | Lingkaran berisi ikon pada `InfoCard`, dan ikon pada tombol aksi. |
   | 19 | `ItemCard` | Widget buatan sendiri: tombol aksi berupa kartu berwarna (Lihat Experience, Tambah Experience, Logout). |
   | 20 | `Material` | Permukaan Material dengan warna latar (`item.color`) dan sudut membulat untuk `ItemCard`. |
   | 21 | `InkWell` | Membuat area bisa ditekan, dengan efek riak dan callback `onTap`. |
   | 22 | `SnackBar` | Pesan singkat "Kamu telah menekan tombol [Nama Tombol]!", ditampilkan lewat `ScaffoldMessenger`. |
   | 23 | `Theme` | Mengambil warna tema (`Theme.of(context)`) untuk `AppBar`, `InfoCard`, dan header. |

3. **Fungsi `MaterialApp` dan alasan menjadi root.**
   `MaterialApp` membungkus aplikasi dengan fondasi Material Design: tema (`ThemeData`), halaman awal (`home`), sistem routing/`Navigator`, lokalisasi, dan `ScaffoldMessenger` yang dibutuhkan untuk menampilkan SnackBar. Widget seperti `Scaffold`, `AppBar`, dan `Theme.of(context)` bergantung pada konteks yang disediakan `MaterialApp`, sehingga widget ini lazim diletakkan di akar pohon agar semua widget di bawahnya otomatis mendapat tema dan navigasi yang konsisten.

4. **StatelessWidget vs StatefulWidget.**

   | | StatelessWidget | StatefulWidget |
   | --- | --- | --- |
   | State | Tidak punya state yang berubah | Punya objek `State` yang berubah selama widget hidup |
   | Rebuild | Hanya saat parent membuatnya ulang | Saat `setState()` dipanggil |
   | Struktur | Satu kelas dengan `build` | Dua kelas: widget dan `State` (`initState`, `dispose`, dll.) |
   | Di proyek ini | `MyApp`, `MyHomePage`, `InfoCard`, `ItemCard` | Belum ada (semua widget bersifat statis) |

   `StatelessWidget` tidak menyimpan state yang berubah: tampilannya hanya ditentukan oleh properti yang diberikan saat dibuat. `StatefulWidget` punya objek `State` terpisah yang menyimpan data berubah dan memanggil `setState()` untuk memicu rebuild. Pilih `StatelessWidget` untuk tampilan statis atau yang datanya sepenuhnya berasal dari luar (di proyek ini: `MyHomePage`, `InfoCard`, `ItemCard`). Pilih `StatefulWidget` ketika widget perlu mengelola state lokal yang berubah, misalnya isian form, counter, atau resource dengan lifecycle seperti `TextEditingController` yang dibersihkan di `dispose()`.

5. **BuildContext.**
   `BuildContext` adalah handle yang menunjuk lokasi sebuah widget di dalam widget tree. Lewat context, widget dapat mencari data dari ancestor-nya, misalnya `Theme.of(context)`, `Navigator.of(context)`, dan `ScaffoldMessenger.of(context)`. Metode `build(BuildContext context)` menerima context milik widget itu sendiri. Di proyek ini context dipakai untuk mengambil warna tema (`Theme.of(context)`) pada `AppBar`, `InfoCard`, dan header, serta menampilkan SnackBar lewat `ScaffoldMessenger.of(context)` pada `ItemCard`. Karena context menunjuk posisi tertentu, context yang salah (misalnya milik widget di atas `Scaffold`) bisa gagal menemukan ancestor yang dicari.

6. **Hot reload vs hot restart.**

   | | Hot reload (`r`) | Hot restart (`R`) | Full restart |
   | --- | --- | --- | --- |
   | Kode baru dimuat | Ya | Ya | Ya |
   | State dipertahankan | Ya | Tidak | Tidak |
   | `main()` dijalankan ulang | Tidak | Ya | Ya |
   | Cara | tekan `r` | tekan `R` | stop, lalu `flutter run` lagi |

   Hot reload menyuntikkan kode yang berubah ke Dart VM yang sedang berjalan lalu membangun ulang widget tree, dengan state aplikasi tetap dipertahankan; cepat dan cocok untuk mengubah UI. Hot restart memuat ulang seluruh kode dan menjalankan `main()` dari awal sehingga state hilang. Hot reload tidak cukup, dan perlu hot restart atau full restart, ketika: mengubah `main()`, nilai inisialisasi variabel global atau `static` yang sudah terlanjur dibuat, mengubah enum atau jenis tipe, atau mengubah `StatelessWidget` menjadi `StatefulWidget`. Full restart (stop lalu `flutter run` lagi) dibutuhkan saat mengubah kode native atau konfigurasi: `pubspec.yaml` (dependency, aset, font), `AndroidManifest.xml`, `Info.plist`, atau plugin baru.

## AI Disclosure

Dalam Tugas 7, saya menggunakan Claude sebagai alat bantu untuk memahami konsep dasar Flutter seperti widget tree, StatelessWidget dan StatefulWidget, BuildContext, serta hot reload dan hot restart, juga untuk membantu proses pengembangan dan perbaikan kode program. Claude juga digunakan untuk membantu mencari penyebab error, serta memberikan saran terkait struktur kode dan tampilan aplikasi. Meskipun menggunakan AI sebagai alat bantu, saya tetap mempelajari, memeriksa, menyesuaikan, dan menguji setiap kode atau saran yang diberikan, termasuk menjalankan sendiri flutter analyze dan flutter test, agar sesuai dengan kebutuhan proyek dan pemahaman saya.

Link log chat AI: https://claude.ai/share/3956f6c0-4d27-4dde-b326-96cef8e16e5d