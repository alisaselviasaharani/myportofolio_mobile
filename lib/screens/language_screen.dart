
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/flag_icons.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:provider/provider.dart';

/// Halaman pemilihan Bahasa Indonesia dan English.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final settings = context.watch<AppSettings>();
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(title: strings.language),

      // Bottom navigation
      bottomNavigationBar: const OceanBottomBar(),

      body: OceanBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 120),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: OceanColors.deep.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _LanguageOption(
                  key: const Key('languageOption_id'),
                  flag: const IndonesiaFlag(),
                  label: strings.indonesian,
                  selected: settings.language == AppLanguage.id,
                  onTap: () {
                    settings.setLanguage(AppLanguage.id);
                  },
                ),
                const SizedBox(height: 12),
                _LanguageOption(
                  key: const Key('languageOption_en'),
                  flag: const UkFlag(),
                  label: strings.english,
                  selected: settings.language == AppLanguage.en,
                  onTap: () {
                    settings.setLanguage(AppLanguage.en);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    super.key,
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Widget flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color _checkColor = Color(0xFF7C4DDB);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              flag,
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? _checkColor : Colors.white,
                  border: Border.all(
                    color: selected
                        ? _checkColor
                        : const Color(0xFF7FC4EA),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 22,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
