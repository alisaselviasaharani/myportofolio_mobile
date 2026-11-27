import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';

/// Tab pada [OceanBottomBar].
enum OceanTab { home, portfolio, favorite, profile }

/// Bottom navigation bar melayang bergaya laut: Beranda, Portofolio, tombol
/// tambah di tengah, Favorit, dan Profil (label ikut bahasa aktif).
///
/// Beranda membersihkan stack lalu membuka [MyHomePage]; Portofolio membuka
/// daftar pengalaman; tombol tengah membuka lembar pilihan form. Favorit dan
/// Profil masih placeholder.
class OceanBottomBar extends StatelessWidget {
  const OceanBottomBar({super.key, this.homeSelected = false, this.selected});

  /// `true` jika bar dipasang di halaman utama (ikon Beranda aktif).
  final bool homeSelected;

  /// Tab yang tersorot (ungu). Jika `null` dan [homeSelected] `true`, Beranda.
  final OceanTab? selected;

  OceanTab? get _active => selected ?? (homeSelected ? OceanTab.home : null);

  void _goHome(BuildContext context) {
    if (homeSelected) {
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
      (route) => false,
    );
  }

  void _openPortfolio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExperienceListScreen()),
    );
  }

  void _showAddSheet(BuildContext context) {
    final strings = AppStrings.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        // Menutup lembar, lalu membuka halaman dengan Navigator.push().
        void open(Widget page) {
          Navigator.pop(sheetContext);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  strings.addData,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.work_outline),
                title: const Text('Add Experience'),
                onTap: () => open(const ExperienceFormPage()),
              ),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Add Education'),
                onTap: () => open(const EducationFormPage()),
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events_outlined),
                title: const Text('Add Achievement'),
                onTap: () => open(const AchievementFormPage()),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _comingSoon(BuildContext context, String label) {
    final strings = AppStrings.of(context);
    showInfoSnackBar(context, '$label ${strings.comingSoon}');
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: OceanColors.deep.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _BarItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: strings.navHome,
                selected: _active == OceanTab.home,
                onPressed: () => _goHome(context),
              ),
              _BarItem(
                icon: Icons.work_outline,
                selectedIcon: Icons.work,
                label: strings.navPortfolio,
                selected: _active == OceanTab.portfolio,
                onPressed: () => _openPortfolio(context),
              ),
              Expanded(
                child: Center(
                  child: Tooltip(
                    message: strings.navAdd,
                    child: GestureDetector(
                      onTap: () => _showAddSheet(context),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3CD0C4), Color(0xFF138FA0)],
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: OceanColors.deep.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _BarItem(
                icon: Icons.star_border,
                selectedIcon: Icons.star,
                label: strings.navFavorite,
                selected: _active == OceanTab.favorite,
                onPressed: () => _comingSoon(context, strings.navFavorite),
              ),
              _BarItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: strings.navProfile,
                selected: _active == OceanTab.profile,
                onPressed: () => _comingSoon(context, strings.navProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu item bar: ikon di atas, label kecil di bawah. Tersorot = ungu.
class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  static const Color _activeColor = Color(0xFF4A2FD0);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _activeColor : OceanColors.navy;
    return Expanded(
      child: Tooltip(
        message: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? selectedIcon : icon, color: color, size: 28),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
