import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';

/// Kepala form: ilustrasi besar, judul, dan subjudul di tengah.
///
/// Dipakai dengan `extendBodyBehindAppBar`, jadi padding atasnya sudah
/// memperhitungkan tinggi header.
class FormHeader extends StatelessWidget {
  const FormHeader({
    super.key,
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final FormKind kind;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 6, 16, 10),
        child: Column(
          children: [
            FormIllustration(kind: kind, width: 150),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: OceanColors.navy,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OceanColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}
