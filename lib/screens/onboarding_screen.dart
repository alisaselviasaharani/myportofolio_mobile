import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/intro_store.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/mascots.dart';
import 'package:myportofolio_mobile/widgets/ocean_bubbles.dart';

/// Tiga halaman perkenalan (geser atau tekan panah). Setelah halaman terakhir
/// atau "Lewati", onboarding ditandai selesai lalu membuka [LoginScreen].
///
/// Ilustrasi tiap halaman dimuat dari `assets/images/onboarding_1.png`,
/// `onboarding_2.png`, dan `onboarding_3.png`. Jika file belum ada, dipakai
/// ilustrasi pengganti yang digambar dengan kode.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const List<_PageData> _pages = [
    _PageData(
      asset: 'assets/images/onboarding_1.png',
      title: 'Kelola Perjalananmu',
      body:
          'Simpan dan atur riwayat pendidikan, pengalaman, proyek, '
          'sertifikasi, dan pencapaianmu dalam satu aplikasi.',
      art: _BooksArt(),
    ),
    _PageData(
      asset: 'assets/images/onboarding_2.png',
      title: 'Tampilkan Keahlianmu',
      body:
          'Bangun portofolio digital yang rapi, menarik, dan '
          'mencerminkan potensimu di bidang teknologi.',
      art: _LaptopArt(),
    ),
    _PageData(
      asset: 'assets/images/onboarding_3.png',
      title: 'Lacak Perkembanganmu',
      body:
          'Pantau perjalanan, capai target, dan rayakan setiap '
          'pencapaian bermakna.',
      art: _TrophyArt(),
    ),
  ];

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await IntroStore.markOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen(entry: true)),
    );
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar bawah laut cerah dengan karang di dasar.
          Image.asset(
            'assets/images/auth_bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8EE3F7), Color(0xFFC9F4FC)],
                ),
              ),
            ),
          ),
          const Positioned.fill(child: OceanBubbles()),
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, i) => _OnboardingPage(data: _pages[i]),
          ),
          // Lewati (disembunyikan di halaman terakhir).
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: _isLast
                  ? const SizedBox(height: 48)
                  : AuthLink(
                      key: const Key('onboardingSkip'),
                      label: 'Lewati',
                      onTap: _finish,
                    ),
            ),
          ),
          // Titik halaman dan tombol panah.
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: SizedBox(
                  height: 68,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < _pages.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: i == _index ? 12 : 9,
                              height: i == _index ? 12 : 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == _index
                                    ? AuthColors.link
                                    : AuthColors.purpleStart.withValues(
                                        alpha: 0.7,
                                      ),
                              ),
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _NextButton(
                          key: const Key('onboardingNext'),
                          onTap: _next,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  const _PageData({
    required this.asset,
    required this.title,
    required this.body,
    required this.art,
  });

  final String asset;
  final String title;
  final String body;

  /// Ilustrasi pengganti jika [asset] belum ada.
  final Widget art;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, top + 40, 20, 8),
            child: Center(
              child: Image.asset(
                data.asset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => data.art,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: ClipPath(
            clipper: const _TopWaveClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 56, 32, 120),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.6),
                    Colors.white.withValues(alpha: 0.35),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 27,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: OceanColors.navy,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data.body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: OceanColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Memotong tepi atas panel teks menjadi gelombang air.
class _TopWaveClipper extends CustomClipper<Path> {
  const _TopWaveClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    return Path()
      ..moveTo(0, 28)
      ..quadraticBezierTo(w * 0.22, 0, w * 0.5, 24)
      ..quadraticBezierTo(w * 0.78, 48, w, 14)
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _TopWaveClipper oldClipper) => false;
}

/// Tombol panah bulat ungu dengan cincin putih.
class _NextButton extends StatelessWidget {
  const _NextButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Lanjut',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AuthColors.purpleStart, AuthColors.purpleEnd],
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AuthColors.purpleEnd.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ilustrasi pengganti (dipakai jika file onboarding_N.png belum ada).
// ---------------------------------------------------------------------------

/// Halaman 1: tumpukan buku di atas lingkaran kaca.
class _BooksArt extends StatelessWidget {
  const _BooksArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFC3B4F5), Color(0xFF8E73E0)],
            ),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const Icon(Icons.auto_stories, color: Colors.white, size: 110),
        ),
        const Positioned(top: 4, right: 8, child: StarfishMascot(size: 56)),
      ],
    );
  }
}

/// Halaman 2: laptop dengan simbol </> dan ikan badut.
class _LaptopArt extends StatelessWidget {
  const _LaptopArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 230,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E88E5), Color(0xFF0B5FB0)],
                ),
                border: Border.all(color: const Color(0xFFEAF3FB), width: 7),
              ),
              child: const Text(
                '</>',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 270,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FB),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        const Positioned(top: 8, left: 0, child: ClownfishMascot(width: 66)),
      ],
    );
  }
}

/// Halaman 3: piala emas.
class _TrophyArt extends StatelessWidget {
  const _TrophyArt();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.emoji_events,
      size: 220,
      color: Color(0xFFF5B301),
    );
  }
}
