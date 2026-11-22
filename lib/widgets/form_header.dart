import 'package:material_ui/material_ui.dart';

/// Kepala form: emoji besar, judul, dan subjudul di tengah.
///
/// Teks berwarna putih dengan bayangan agar terbaca di atas gambar latar.
class FormHeader extends StatelessWidget {
  const FormHeader({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;

  static const List<Shadow> _shadows = [
    Shadow(color: Color(0x66000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: _shadows,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: _shadows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
