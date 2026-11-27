import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/onboarding_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/intro_store.dart';
import 'package:provider/provider.dart';

/// Layar pembuka: ilustrasi "Alisa's Portfolio", logo teratai, dan bar
/// loading yang terisi.
///
/// Selama bar terisi, aplikasi memuat sesi tersimpan ("Ingat saya") dan status
/// onboarding. Setelah itu pindah ke:
/// - [OnboardingScreen] jika baru pertama kali dibuka,
/// - [MyHomePage] jika sesi login tersimpan,
/// - [LoginScreen] selain itu.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2600),
  });

  /// Lama bar loading terisi penuh.
  final Duration duration;

  /// Gambar latar (harus terdaftar di `pubspec.yaml`).
  static const String backgroundAsset = 'assets/images/splash_bg.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _start();
  }

  Future<void> _start() async {
    final auth = context.read<AuthState>();
    final seenFuture = IntroStore.hasSeenOnboarding();
    final restoreFuture = auth.restore();

    // Bar loading berjalan sambil data dimuat; pindah setelah keduanya selesai.
    await _controller.forward();
    final seen = await seenFuture;
    await restoreFuture;
    if (!mounted) return;

    final Widget next;
    if (!seen) {
      next = const OnboardingScreen();
    } else if (auth.isLoggedIn) {
      next = MyHomePage();
    } else {
      next = const LoginScreen(entry: true);
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            SplashScreen.backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1AA7D6), Color(0xFF8EE3F7)],
                ),
              ),
            ),
          ),
          // Logo teratai di atas judul.
          const Align(
            alignment: Alignment(0, -0.84),
            child: SizedBox(
              width: 64,
              height: 48,
              child: CustomPaint(painter: _LotusPainter()),
            ),
          ),
          // Bar loading.
          Align(
            alignment: const Alignment(0, 0.86),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: _LoadingBar(animation: _controller),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bar loading kapsul: bingkai putih tipis dengan isi gradasi tosca.
class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('splashLoadingBar'),
      height: 18,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: Curves.easeInOut.transform(animation.value),
            heightFactor: 1,
            child: child,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF59D4EC), Color(0xFF9BEBF7)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo teratai garis putih (tiga kelopak dan dasar melengkung).
class _LotusPainter extends CustomPainter {
  const _LotusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    final w = size.width;
    final h = size.height;
    final base = Offset(w / 2, h * 0.86);

    Path petal(double length, double width) {
      return Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(width, -length * 0.5, 0, -length)
        ..quadraticBezierTo(-width, -length * 0.5, 0, 0);
    }

    // Kelopak tengah.
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.drawPath(petal(h * 0.8, w * 0.2), paint);
    // Kelopak kiri dan kanan.
    for (final angle in const [-0.95, 0.95]) {
      canvas.save();
      canvas.rotate(angle);
      canvas.drawPath(petal(h * 0.62, w * 0.17), paint);
      canvas.restore();
    }
    canvas.restore();

    // Dasar melengkung di bawah kelopak.
    final bowl = Path()
      ..moveTo(w * 0.1, h * 0.7)
      ..quadraticBezierTo(w * 0.28, h * 1.02, w * 0.5, h * 0.98)
      ..quadraticBezierTo(w * 0.72, h * 1.02, w * 0.9, h * 0.7);
    canvas.drawPath(bowl, paint);
  }

  @override
  bool shouldRepaint(covariant _LotusPainter oldDelegate) => false;
}
