import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Warna aksen halaman auth (ungu, sesuai mockup).
class AuthColors {
  const AuthColors._();

  static const Color purpleStart = Color(0xFFA188EE);
  static const Color purpleEnd = Color(0xFF7B5BD6);

  /// Ungu tua untuk tautan dan kotak centang (kontras baik di atas latar biru).
  static const Color link = Color(0xFF4B2FB5);
}

/// Field berbentuk kapsul kaca dengan ikon di kiri. Jika [isPassword], ada
/// tombol mata untuk menampilkan atau menyembunyikan kata sandi.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.autofillHints,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _hidden = true;

  OutlineInputBorder _border(Color color, [double width = 1.5]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final border = Colors.white.withValues(alpha: 0.9);
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: widget.isPassword && _hidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      autocorrect: false,
      enableSuggestions: !widget.isPassword,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: OceanColors.navy,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Color(0xFF5B6A94),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(widget.icon),
        prefixIconColor: OceanColors.navy,
        suffixIconColor: OceanColors.navy,
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _hidden
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                icon: Icon(
                  _hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _hidden = !_hidden),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.72),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: _border(border),
        enabledBorder: _border(border),
        disabledBorder: _border(border),
        focusedBorder: _border(AuthColors.purpleEnd, 2),
        errorBorder: _border(const Color(0xFFC62F3F)),
        focusedErrorBorder: _border(const Color(0xFFC62F3F), 2),
        errorStyle: const TextStyle(
          color: Color(0xFFB3202F),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Tombol utama ungu berbentuk kapsul. Saat [loading] tombol menonaktifkan
/// diri dan menampilkan indikator putar.
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = !loading;
    return Opacity(
      opacity: enabled ? 1 : 0.75,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AuthColors.purpleStart, AuthColors.purpleEnd],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AuthColors.purpleEnd.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: Center(
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 24, color: Colors.white),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tautan teks tebal (mis. "Lupa Kata Sandi?", "Kembali ke Login").
class AuthLink extends StatelessWidget {
  const AuthLink({
    super.key,
    required this.label,
    required this.onTap,
    this.underline = false,
    this.color = AuthColors.link,
  });

  final String label;
  final VoidCallback onTap;
  final bool underline;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: color,
        ),
      ),
    );
  }
}

/// Kalimat tanya diikuti tautan aksi, mis. "Sudah punya akun? Masuk".
class AuthPrompt extends StatelessWidget {
  const AuthPrompt({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: OceanColors.navy,
          ),
        ),
        AuthLink(label: action, onTap: onTap, underline: true),
      ],
    );
  }
}

/// Garis pemisah dengan teks di tengah, mis. "atau masuk dengan".
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: Colors.white.withValues(alpha: 0.9), height: 1),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: OceanColors.navy,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

/// Tombol bulat putih untuk login pihak ketiga.
class SocialCircleButton extends StatelessWidget {
  const SocialCircleButton({
    super.key,
    required this.tooltip,
    required this.onTap,
    required this.child,
    this.background = Colors.white,
  });

  final String tooltip;
  final VoidCallback onTap;
  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: OceanColors.deep.withValues(alpha: 0.4),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 54,
            height: 54,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
