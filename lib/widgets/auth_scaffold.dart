import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/ocean_bubbles.dart';

/// Posisi maskot pada kepala halaman auth.
enum AuthHeaderStyle {
  /// Judul rata kiri, maskot di sisi kanan (Login, Daftar Akun).
  side,

  /// Maskot, judul, dan subjudul di tengah (Lupa dan Atur Ulang Kata Sandi).
  centered,
}

/// Kerangka halaman auth: latar bawah laut cerah, gelembung, kepala halaman
/// ([mascot], [title], [subtitle]), lalu [children] di bawahnya.
///
/// Jika [formKey] diberikan, isi halaman dibungkus [Form]. Tombol kembali
/// tampil otomatis saat halaman bisa di-pop.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mascot,
    required this.children,
    this.headerStyle = AuthHeaderStyle.side,
    this.formKey,
  });

  final String title;
  final String subtitle;
  final Widget mascot;
  final List<Widget> children;
  final AuthHeaderStyle headerStyle;
  final GlobalKey<FormState>? formKey;

  /// Latar khusus halaman auth (lebih cerah daripada `ocean_bg.jpg`).
  static const String backgroundAsset = 'assets/images/auth_bg.jpg';

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 20),
        ...children,
      ],
    );
    if (formKey != null) {
      content = Form(key: formKey, child: content);
    }

    return Scaffold(
      // Latar tidak ikut menyusut saat keyboard muncul; isinya yang menggulir.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gambar didorong 14% ke bawah layar agar karang hanya tampak kecil
          // di dasar, lalu diberi kabut putih tipis agar warnanya lebih pucat.
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: -constraints.maxHeight * 0.14,
                    child: Image.asset(
                      backgroundAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (context, error, stackTrace) =>
                          const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF8EE3F7), Color(0xFFC9F4FC)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x40FFFFFF),
                          Color(0x59FFFFFF),
                          Color(0x59FFFFFF),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned.fill(child: OceanBubbles()),
          SafeArea(
            child: Column(
              children: [
                if (Navigator.canPop(context))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: 'Kembali',
                      icon: const Icon(
                        Icons.arrow_back,
                        color: OceanColors.navy,
                        size: 28,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 100 + keyboard),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    const titleStyle = TextStyle(
      fontSize: 30,
      height: 1.1,
      fontWeight: FontWeight.w800,
      color: OceanColors.navy,
    );
    const subtitleStyle = TextStyle(
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: OceanColors.navy,
    );

    if (headerStyle == AuthHeaderStyle.centered) {
      return Column(
        children: [
          mascot,
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: titleStyle),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: subtitleStyle),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              const SizedBox(height: 10),
              Text(subtitle, style: subtitleStyle),
            ],
          ),
        ),
        const SizedBox(width: 8),
        mascot,
      ],
    );
  }
}
