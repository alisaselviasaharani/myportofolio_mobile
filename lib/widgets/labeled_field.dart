import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Membungkus sebuah field dengan label tebal di atasnya, dan tanda bintang
/// merah jika [isRequired]. Sekaligus memberi jarak antarfield.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
    this.isOptional = false,
  });

  final String label;
  final Widget child;
  final bool isRequired;

  /// Menambahkan teks ringan " (opsional)" setelah label.
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text.rich(
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: OceanColors.navy,
                ),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: OceanColors.coral),
                    ),
                  if (isOptional)
                    const TextSpan(
                      text: ' (opsional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
