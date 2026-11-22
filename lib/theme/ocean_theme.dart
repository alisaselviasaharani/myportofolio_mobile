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
}

/// Tema aplikasi: skema warna dari [OceanColors], `primary` = [OceanColors.deep].
ThemeData buildOceanTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: OceanColors.deep,
      primary: OceanColors.deep,
      secondary: OceanColors.teal,
    ),
    scaffoldBackgroundColor: OceanColors.foam,
    useMaterial3: true,
  );
}

/// AppBar seragam untuk semua halaman. Tombol drawer/kembali otomatis muncul
/// sesuai `Scaffold` pemakainya.
AppBar oceanAppBar({required String title, List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    backgroundColor: OceanColors.deep,
    foregroundColor: Colors.white,
    elevation: 0,
    actions: actions,
    // Gradasi biru tua ke tosca di belakang judul.
    flexibleSpace: const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [OceanColors.deep, OceanColors.teal],
        ),
      ),
    ),
  );
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
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black38),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    counterText: showCounter ? null : '',
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: border(OceanColors.aqua),
    enabledBorder: border(OceanColors.aqua),
    focusedBorder: border(OceanColors.deep, 2.0),
    errorBorder: border(OceanColors.coral, 1.5),
    focusedErrorBorder: border(OceanColors.coral, 2.0),
  );
}
