import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/form_card.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:provider/provider.dart';

/// Halaman login: menukar username + password Django menjadi token DRF.
///
/// Mengembalikan `true` lewat `Navigator.pop(context, true)` jika berhasil,
/// sehingga bisa dipakai oleh `ensureLoggedIn`.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthState>();
    setState(() {
      _isSubmitting = true;
    });

    try {
      await auth.login(_username.trim(), _password);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      showInfoSnackBar(
        context,
        'Login gagal (status ${e.statusCode}). Periksa username dan password.',
      );
    } catch (e) {
      // Mis. server mati, alamat salah, atau CORS (di Chrome).
      if (!mounted) return;
      showInfoSnackBar(
        context,
        'Tidak dapat terhubung ke $apiBaseUrl: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: 'Login'),
      body: OceanBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, top + 16, 16, 12),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 64,
                            color: OceanColors.navy,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: OceanColors.navy,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Login untuk menambahkan experience.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: OceanColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FormCard(
                      children: [
                        LabeledField(
                          label: 'Username',
                          isRequired: true,
                          child: TextFormField(
                            key: const Key('usernameField'),
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: oceanInputDecoration(
                              hint: 'Username',
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            onChanged: (value) => _username = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username cannot be empty!';
                              }
                              return null;
                            },
                          ),
                        ),
                        LabeledField(
                          label: 'Password',
                          isRequired: true,
                          child: TextFormField(
                            key: const Key('passwordField'),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: oceanInputDecoration(
                              hint: 'Password',
                              prefixIcon: const Icon(Icons.key_outlined),
                            ),
                            onChanged: (value) => _password = value,
                            onFieldSubmitted: (_) {
                              if (!_isSubmitting) _submit();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}