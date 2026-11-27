import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

enum OceanNavItem { home, portfolio, favorite, profile }

class OceanBottomBar extends StatelessWidget {
  const OceanBottomBar({super.key, this.selectedItem = OceanNavItem.home});

  final OceanNavItem selectedItem;

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MyHomePage()),
      (route) => false,
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        void open(Widget page) {
          Navigator.pop(sheetContext);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }

        return Material(
          color: const Color(0xFFF1FAFF),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Tambah data',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: OceanColors.navy,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Add Education'),
                  onTap: () => open(const EducationFormPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Add Experience'),
                  onTap: () => open(const ExperienceFormPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('Add Certification'),
                  onTap: () => open(const AchievementFormPage()),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required OceanNavItem item,
    required VoidCallback onTap,
  }) {
    final active = selectedItem == item;

    return Expanded(
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 31,
                  color: active ? OceanColors.seaGreen : OceanColors.navy,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                    color: OceanColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: active ? 18 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: OceanColors.seaGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.95),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: OceanColors.deep.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                _navItem(
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  item: OceanNavItem.home,
                  onTap: () => _goHome(context),
                ),
                _navItem(
                  icon: Icons.work_outline,
                  label: 'Portofolio',
                  item: OceanNavItem.portfolio,
                  onTap: () {},
                ),
                Expanded(
                  child: Center(
                    child: Material(
                      color: OceanColors.seaGreen,
                      elevation: 7,
                      shape: const CircleBorder(),
                      child: Tooltip(
                        message: 'Tambah',
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _showAddSheet(context),
                          child: const SizedBox(
                            width: 66,
                            height: 66,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 43,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _navItem(
                  icon: Icons.star_border_rounded,
                  label: 'Favorit',
                  item: OceanNavItem.favorite,
                  onTap: () {},
                ),
                _navItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  item: OceanNavItem.profile,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
