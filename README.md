# MyPortfolio Mobile

Aplikasi mobile Flutter untuk **portofolio pribadi**, pendamping website portofolio Django (repositori terpisah). Dikembangkan bertahap mengikuti Tutorial dan Individual Assignment mingguan mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI.

| | |
| --- | --- |
| **Nama** | Alisa Selvia Saharani |
| **NPM** | 2506618433 |
| **Kelas** | PBP D |

## Kebutuhan Instalasi

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable). Dart sudah termasuk.
- Git.
- Salah satu target untuk menjalankan aplikasi: Chrome (web), emulator Android, atau perangkat fisik.
- Editor, misalnya VS Code (ekstensi Flutter) atau Android Studio.

## Instruksi Setup

1. Clone repositori lalu masuk ke folder proyek (folder yang berisi `pubspec.yaml`):
   ```bash
   git clone https://github.com/alisaselviasaharani/myportofolio_mobile.git
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
| [Tutorial 09](https://pbp.cs.ui.ac.id/tutorial/tutorial-9.html) | Flutter Navigation, Layouts, Forms, and Input Elements | Drawer (left_drawer.dart), halaman form tambah item (itemlist_form.dart) dengan TextFormField dan validasi, navigasi Navigator.push/pushReplacement, showDialog untuk menampilkan data hasil input, refactor file ke folder screens/ dan widgets/ |
| [Tugas 8](https://pbp.cs.ui.ac.id/assignments/individual/tugas-8.html) | Flutter Navigation, Layouts, Forms, and Input Elements | Drawer dengan navigasi ke halaman utama dan halaman form, form tambah item dengan validasi, tombol Tambah Item mengarah ke form, Navigator.push/pushReplacement, dan showDialog untuk data tersimpan |

## Tugas 7

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


## Tugas 8

**Ringkasan implementasi.** Dua formulir baru diambil dari model website Django (`main/models.py`): **Education** (sesuai desain mockup) dan **Achievements**. Experience sudah dipakai di Tutorial 09. Tampilan mengikuti mockup bertema laut: gradasi biru, gelembung, input membulat berlatar putih, dan dialog ringkasan.

| Input | Widget | Aturan validasi |
| --- | --- | --- |
| Nama Penghargaan | `TextFormField` | wajib, tidak boleh kosong/hanya spasi, maks. 255 karakter (sesuai model) |
| Deskripsi Penghargaan | `TextFormField` (multi-baris) | wajib, tidak boleh kosong/hanya spasi, maks. 500 karakter (aturan aplikasi mobile) |
| Kategori Penghargaan | `DropdownButtonFormField` | Academic, Competition, Certification, Award, Other (sesuai model) |
| Tanggal Mulai | `TextFormField` read-only + `showDatePicker()` | wajib dipilih |
| Tanggal Selesai (opsional) | `TextFormField` read-only + `showDatePicker()` | tidak boleh sebelum tanggal mulai |
| URL Gambar (opsional) | `TextFormField` | jika diisi harus `http`/`https` dengan host, tanpa spasi, maks. 500 karakter (sesuai model) |

**Form Add Education** (`education_form.dart`):

| Input | Widget | Aturan validasi |
| --- | --- | --- |
| Institusi | `TextFormField` | wajib, tidak boleh kosong/hanya spasi, maks. 100 karakter (sesuai model) |
| Jenjang | `DropdownButtonFormField` | SMA/SMK, D3, S1, S2, S3 |
| Jurusan | `TextFormField` | wajib, maks. 90 karakter (agar `S1 - Jurusan` < 100 karakter) |
| Tanggal Mulai | `showDatePicker()` | wajib dipilih |
| Tanggal Selesai | `showDatePicker()` | wajib, tidak boleh sebelum tanggal mulai |
| Website (opsional) | `TextFormField` | jika diisi harus `http`/`https` dengan host, maks. 255 karakter (sesuai model) |

Dialog "Education Saved!" menampilkan Institution, Degree (mis. `S1 - Ilmu Komputer`), Start Date, End Date, dan Website; tombol OK menutup dialog dan mereset form.

**Form Add Achievement** (`achievement_form.dart`) memakai tabel berikut.

Catatan desain: pada model Django, `period` berupa teks bebas. Di mobile, periode disusun dari dua tanggal (mis. `19 Okt 2026 - 27 November 2027`, selalu di bawah batas 50 karakter) agar urutan tanggal bisa divalidasi.

Alur dan struktur:

- Kartu aksi **Tambah Education** dan **Tambah Achievement** di halaman utama membuka form lewat `Navigator.push()`. Tujuan kartu disimpan di `ItemHomepage.pageBuilder`, sehingga `ItemCard` tidak perlu percabangan per nama tombol.
- Drawer yang sama (`LeftDrawer`) dipakai di halaman utama, form Experience, dan form Achievement. Opsi Home dan Add Experience dipertahankan, ditambah Add Education dan Add Achievement; item halaman aktif tersorot lewat parameter `selected`.
- Tombol **Simpan** memanggil `FormState.validate()`. Dialog ringkasan (`AlertDialog` lewat `showDialog()`) hanya muncul jika semua input valid, dan tombol **Tutup** menutup dialog lalu mereset form.
- Logika validasi dipisah ke `lib/utils/validators.dart` (fungsi murni) dan diuji tanpa UI.

**Pengujian manual** (berlaku untuk form Education dan Achievement): buka form dari kartu dan dari drawer; kosongkan input wajib lalu tekan Simpan (pesan error muncul pada kolom terkait); isi nama dengan spasi saja (ditolak); isi URL `www.google.com` (ditolak); lengkapi isian lalu Simpan (dialog menampilkan data); tekan Tutup (form kosong kembali); buka drawer lalu Home (kembali ke halaman utama); ulangi di lebar layar ponsel.

**Hasil pengujian:**
- `flutter analyze` → **No issues found!** (ran in 9.6s).
- `flutter test` → **All tests passed!** (43 tests passed).

**Pertanyaan Reflektif**

1. **`push()`, `pushReplacement()`, dan `pop()`.**
   `Navigator.push()` menambahkan route baru di atas stack sehingga route lama tetap ada di bawahnya. `Navigator.pushReplacement()` mengganti route teratas dengan route baru, jadi route lama dibuang dari stack. `Navigator.pop()` membuang route teratas dan kembali ke route di bawahnya. Untuk membuka formulir dari kartu aksi dipakai `Navigator.push()` (di `ItemCard`, lewat `item.pageBuilder`), sehingga tombol kembali bawaan perangkat atau `pop()` mengembalikan pengguna ke halaman utama. Opsi Home di drawer memakai `Navigator.pushReplacement()` ke `MyHomePage()`: halaman form yang sedang tampil diganti dengan halaman utama. Perlu dicatat, hanya route teratas yang diganti. Jika form dibuka dari kartu (stack: Home, Form), memilih Home di drawer menghasilkan stack Home, Home, sehingga menekan kembali sekali lagi menuju halaman utama yang lama.

2. **Scaffold, AppBar, dan Drawer.**
   `Scaffold` memberi kerangka tetap (AppBar di atas, drawer di sisi kiri, body, dan tempat SnackBar), sehingga setiap halaman memiliki struktur yang sama dan pengguna tahu di mana mencari navigasi. `LeftDrawer` dibuat satu kali lalu dipasang pada `drawer:` di `MyHomePage`, `ExperienceFormPage`, dan `AchievementFormPage`, sehingga menu tidak perlu diulang. Contoh warna tema di lebih dari satu halaman: `OceanColors.deep` (juga menjadi `colorScheme.primary` di `buildOceanTheme()`) dipakai pada `oceanAppBar()` di semua halaman, header gradasi dan judul "Menu" di `menu.dart`, serta tombol Simpan dan judul `FormHeader` di form Education dan Achievement. Karena warna dan gaya input dipusatkan di `ocean_theme.dart`, mengubah tema cukup di satu berkas.

3. **Tata letak formulir.**
   Form disusun sebagai `Form` → `SingleChildScrollView` → `Center` → `ConstrainedBox(maxWidth: 600)` → `Column`. `Column` dipilih karena field berurutan vertikal dan lebih mudah dibaca di layar ponsel. Dua field tanggal sengaja ditumpuk (bukan satu `Row`) agar tidak sempit di layar kecil. `Padding` (8 px) dan `SizedBox` memberi jarak agar field tidak berdempetan dan mudah disentuh. `SingleChildScrollView` penting karena `Column` tidak bisa digulir sendiri: saat papan ketik muncul dan tinggi layar berkurang, field dan tombol Simpan yang tertutup tetap dapat dijangkau dengan menggulir (tanpa itu muncul overflow). `ConstrainedBox` menjaga lebar tetap proporsional di Chrome, dan `keyboardDismissBehavior` menutup papan ketik saat form digulir.

4. **`GlobalKey<FormState>`, `validator`, dan `validate()`.**
   `GlobalKey<FormState>` (`_formKey`) menghubungkan tombol Simpan dengan `FormState` milik `Form`, sehingga kode di luar field dapat memanggil `validate()` dan `reset()`. Setiap `validator` adalah fungsi yang menerima isi field dan mengembalikan pesan error, atau `null` jika valid. Saat Simpan ditekan, `validate()` menjalankan semua validator, menampilkan pesan pada kolom yang gagal, dan mengembalikan `true` hanya jika semuanya valid; dialog baru dibuka setelah itu. Contoh nilai yang ditolak: nama penghargaan `"     "` (hanya spasi), URL `www.google.com` (tanpa skema), atau tanggal selesai yang lebih awal dari tanggal mulai. Memilih jenis input atau papan ketik saja belum cukup karena `TextInputType.url` hanya mengubah tata letak keyboard dan tidak membatasi isi: pengguna tetap bisa mengetik atau menempel teks apa pun, termasuk spasi saja, dan `showDatePicker()` tidak menjamin hubungan antara dua tanggal. Aturan harus dicek oleh validator.

## AI Disclosure
Dalam Tugas 8, saya menggunakan Claude sebagai alat bantu untuk memahami dan menerapkan konsep Flutter seperti Navigator.push(), Navigator.pushReplacement(), Navigator.pop(), Drawer, Form, GlobalKey<FormState>, validator, dan showDialog(). Claude juga digunakan untuk membantu proses pengembangan halaman formulir Education dan Achievement, memberikan saran terkait tata letak dan desain antarmuka, serta membantu proses debugging, mencari penyebab error, dan memperbaiki kode program. Meskipun menggunakan AI sebagai alat bantu, saya tetap mempelajari, memeriksa, menyesuaikan, dan menguji setiap kode atau saran yang diberikan, termasuk menjalankan sendiri flutter analyze dan flutter test, agar sesuai dengan kebutuhan proyek dan pemahaman saya.

Link log chat AI: https://claude.ai/share/680c0840-af01-4534-9371-666993665b07
