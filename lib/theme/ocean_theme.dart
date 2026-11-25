import 'package:material_ui/material_ui.dart';

/// Palet warna bertema laut yang dipakai di seluruh aplikasi.
class OceanColors {
  const OceanColors._();

  static const Color deep = Color(0xFF0B6FA8);
  static const Color teal = Color(0xFF1FB5D4);
  static const Color aqua = Color(0xFFBDEBFA);
  static const Color foam = Color(0xFFEAF9FF);
  static const Color indigo = Color(0xFF5C6BC0);
  static const Color lavender = Color(0xFF9C8CE8);
  static const Color seaGreen = Color(0xFF26A69A);
  static const Color coral = Color(0xFFEF6F6C);

  // Warna pastel untuk kartu aksi di beranda.
  static const Color pastelBlue = Color(0xFFD6E4FF);
  static const Color pastelYellow = Color(0xFFFFF1B8);
  static const Color pastelPink = Color(0xFFF8D6F5);
  static const Color pastelMint = Color(0xFFD3F5E6);

  // Warna tambahan sesuai desain terbaru.
  /// Biru tua untuk teks judul dan ikon.
  static const Color navy = Color(0xFF14245E);

  /// Gradasi header (atas ke bawah).
  static const Color headerTop = Color(0xFF0382B0);
  static const Color headerBottom = Color(0xFF1AA7D6);

  /// Gradasi tombol/pil utama (kiri ke kanan).
  static const Color buttonStart = Color(0xFF0B8DB8);
  static const Color buttonEnd = Color(0xFF1AB4D8);

  /// Latar kartu aksi pada beranda.
  static const Color cardLavender = Color(0xFFDCDAFC);
  static const Color cardYellow = Color(0xFFFAEEBB);
  static const Color cardPurple = Color(0xFFDDDEFD);
  static const Color cardPink = Color(0xFFF0E4FE);
}

/// Tema aplikasi: skema warna dari [OceanColors], `primary` = [OceanColors.deep].
ThemeData buildOceanTheme() {
  return ThemeData(
    // Font bulat Nunito sesuai desain (file ada di assets/fonts/).
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: OceanColors.deep,
      primary: OceanColors.deep,
      secondary: OceanColors.teal,
    ),
    scaffoldBackgroundColor: OceanColors.foam,
    useMaterial3: true,
  );
}

/// Memotong bagian bawah header menjadi gelombang air.
class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({this.depth = 16});

  /// Tinggi area gelombang di bagian bawah.
  final double depth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..lineTo(0, h - depth * 0.6)
      ..quadraticBezierTo(w * 0.25, h - depth * 1.6, w * 0.5, h - depth * 0.7)
      ..quadraticBezierTo(w * 0.78, h + depth * 0.1, w, h - depth * 0.9)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) =>
      oldClipper.depth != depth;
}

/// Tinggi area toolbar dan gelombang header.
const double _toolbarHeight = 60;
const double _waveHeight = 18;

/// Tinggi header (tanpa status bar) agar halaman bisa memberi jarak di atas isi.
const double oceanAppBarHeight = _toolbarHeight + _waveHeight;

/// AppBar seragam untuk semua halaman.
///
/// Latarnya gradasi biru laut dengan tepi bawah bergelombang. Tombol kiri
/// otomatis berupa hamburger (jika `Scaffold` punya drawer) atau panah kembali
/// (jika halaman bisa di-pop). Set [centerTitle] untuk memusatkan judul.
PreferredSizeWidget oceanAppBar({
  required String title,
  List<Widget>? actions,
  bool centerTitle = false,
}) {
  return OceanAppBar(title: title, actions: actions, centerTitle: centerTitle);
}

/// Implementasi header laut (digambar sendiri agar gradasinya pasti tampil).
class OceanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OceanAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(oceanAppBarHeight);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final scaffold = Scaffold.maybeOf(context);

    Widget? leading;
    if (Navigator.canPop(context)) {
      leading = IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        onPressed: () => Navigator.maybePop(context),
      );
    } else if (scaffold != null && scaffold.hasDrawer) {
      leading = IconButton(
        tooltip: 'Open navigation menu',
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: scaffold.openDrawer,
      );
    }

    final titleText = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 22,
      ),
    );

    return SizedBox(
      height: oceanAppBarHeight + top,
      child: Stack(
        children: [
          // Gradasi biru tua ke tosca, dipotong bergelombang di bawah.
          Positioned.fill(
            child: ClipPath(
              clipper: const WaveClipper(depth: _waveHeight),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [OceanColors.headerTop, OceanColors.headerBottom],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top,
            height: _toolbarHeight,
            child: Row(
              children: [
                SizedBox(width: 56, child: leading),
                Expanded(
                  child: centerTitle
                      ? Center(child: titleText)
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: titleText,
                        ),
                ),
                if (actions != null)
                  ...actions!
                else if (centerTitle)
                  const SizedBox(width: 56),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dekorasi input seragam: terisi putih, sudut membulat, dan border merah
/// saat error. Label ditampilkan di atas field lewat `LabeledField`, jadi
/// di sini hanya ada [hint]. Penghitung karakter disembunyikan kecuali
/// [showCounter] `true` (batas panjang tetap berlaku lewat `maxLength`).
InputDecoration oceanInputDecoration({
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool showCounter = false,
}) {
  OutlineInputBorder border(Color color, [double width = 1.0]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black38),
    prefixIconColor: OceanColors.navy,
    suffixIconColor: OceanColors.navy,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    counterText: showCounter ? null : '',
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: border(const Color(0xFFCFEAF5)),
    enabledBorder: border(const Color(0xFFCFEAF5)),
    focusedBorder: border(OceanColors.deep, 2.0),
    errorBorder: border(OceanColors.coral, 1.5),
    focusedErrorBorder: border(OceanColors.coral, 2.0),
  );
}
