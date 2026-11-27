import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/forgot_password_screen.dart';
import 'package:myportofolio_mobile/screens/register_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/auth_errors.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_form_parts.dart';
import 'package:myportofolio_mobile/widgets/auth_scaffold.dart';
import 'package:myportofolio_mobile/widgets/mascots.dart';
import 'package:provider/provider.dart';

/// Halaman login: menukar username + password Django menjadi token DRF.
///
/// Mengembalikan `true` lewat `Navigator.pop(context, true)` jika berhasil,
/// sehingga bisa dipakai oleh `ensureLoggedIn`. Dari sini pengguna juga bisa
/// membuka [RegisterScreen] dan [ForgotPasswordScreen].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    final auth = context.read<AuthState>();
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Backend memeriksa field `username`; isian "email atau username"
      // dikirim apa adanya.
      await auth.login(_identifier.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      showInfoSnackBar(
        context,
        authErrorMessage(
          e,
          failed: 'Login gagal',
          rejected: 'Email/username atau kata sandi salah.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _socialSoon(String provider) {
    showInfoSnackBar(context, 'Masuk dengan $provider belum tersedia.');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formKey: _formKey,
      title: 'Login',
      subtitle: 'Selamat datang kembali!\nMasuk ke akun portfoliomu.',
      mascot: const JellyfishMascot(width: 96),
      children: [
        AuthTextField(
          key: const Key('usernameField'),
          controller: _identifier,
          hint: 'Email atau Username',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          validator: (value) => FormValidators.requiredText(
            value,
            fieldName: 'Email atau username',
          ),
        ),
        const SizedBox(height: 14),
        AuthTextField(
          key: const Key('passwordField'),
          controller: _password,
          hint: 'Kata Sandi',
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => _submit(),
          validator: (value) => (value == null || value.isEmpty)
              ? 'Kata sandi tidak boleh kosong!'
              : null,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _remember = !_remember),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      key: const Key('rememberCheckbox'),
                      value: _remember,
                      onChanged: (value) =>
                          setState(() => _remember = value ?? false),
                      activeColor: AuthColors.purpleEnd,
                      side: const BorderSide(
                        color: OceanColors.navy,
                        width: 2,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Flexible(
                      child: Text(
                        'Ingat saya',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: OceanColors.navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AuthLink(
              label: 'Lupa Kata Sandi?',
              underline: true,
              onTap: () => _open(const ForgotPasswordScreen()),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AuthButton(
          label: 'Masuk',
          loading: _isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: 24),
        const AuthDivider(label: 'atau masuk dengan'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialCircleButton(
              tooltip: 'Masuk dengan Google',
              onTap: () => _socialSoon('Google'),
              child: const Text(
                'G',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4285F4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        AuthPrompt(
          question: 'Belum punya akun?',
          action: 'Daftar',
          onTap: () => _open(const RegisterScreen()),
        ),
      ],
    );
  }
}
