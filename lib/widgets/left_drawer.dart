import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/contact_page.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/skills_page.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';

/// Tujuan pada drawer; dipakai untuk menandai item yang sedang aktif.
enum DrawerDestination {
  home,
  education,
  experience,
  certification,
  skills,
  contact,
}

/// Drawer navigasi yang dipakai bersama oleh semua halaman.
///
/// Setiap halaman mengisi [selected] dengan tujuannya sendiri agar item
/// tersebut tampil tersorot.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, this.selected});

  final DrawerDestination? selected;

  /// Mengganti halaman saat ini dengan [page] (`Navigator.pushReplacement`).
  void _go(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Menu yang halamannya belum dibuat: tutup drawer lalu tampilkan info.
  void _comingSoon(BuildContext context, String label) {
    showInfoSnackBar(context, '$label akan hadir di tahap berikutnya.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFE6F6FC),
      width: 310,
      shape: const RoundedRectangleBorder(),
      child: OceanBackground(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                const _DrawerHeader(),
                const SizedBox(height: 10),
                _DrawerTile(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  selected: selected == DrawerDestination.home,
                  onTap: () => _go(context, MyHomePage()),
                ),
                _DrawerTile(
                  icon: Icons.school_outlined,
                  title: 'Add Education',
                  selected: selected == DrawerDestination.education,
                  onTap: () => _go(context, const EducationFormPage()),
                ),
                _DrawerTile(
                  icon: Icons.work_outline,
                  title: 'Add Experience',
                  selected: selected == DrawerDestination.experience,
                  onTap: () => _go(context, const ExperienceFormPage()),
                ),
                _DrawerTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Add Certification',
                  selected: selected == DrawerDestination.certification,
                  onTap: () => _go(context, const AchievementFormPage()),
                ),
                _DrawerTile(
                  icon: Icons.psychology_outlined,
                  title: 'My Skills',
                  selected: selected == DrawerDestination.skills,
                  onTap: () => _go(context, const SkillsPage()),
                ),
                _DrawerTile(
                  icon: Icons.contact_mail_outlined,
                  title: 'Contact Me',
                  selected: selected == DrawerDestination.contact,
                  onTap: () => _go(context, const ContactPage()),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Divider(color: Color(0xFF9FD3E6), height: 1),
                ),
                _DrawerTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  selected: false,
                  onTap: () => _comingSoon(context, 'About'),
                ),
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  selected: false,
                  onTap: () => _comingSoon(context, 'Settings'),
                ),
                _DrawerTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  selected: false,
                  onTap: () => _comingSoon(context, 'Logout'),
                ),
                const SizedBox(height: 120),
              ],
            ),
            // Kepiting di dasar laut.
            const Positioned(
              left: 70,
              bottom: 22,
              child: CrabMascot(width: 92),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kepala drawer: gradasi biru bergelombang, foto, nama, dan kuda laut.
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ClipPath(
      clipper: const WaveClipper(depth: 26),
      child: Container(
        height: 214 + top,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [OceanColors.headerTop, OceanColors.headerBottom],
          ),
        ),
        child: Stack(
          children: [
            // Gelembung hiasan.
            for (final b in const [
              (right: 40.0, top: 28.0, size: 18.0),
              (right: 16.0, top: 74.0, size: 10.0),
              (right: 84.0, top: 12.0, size: 8.0),
            ])
              Positioned(
                right: b.right,
                top: b.top + top,
                child: Container(
                  width: b.size,
                  height: b.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 14,
              top: 70 + top,
              child: const SeahorseMascot(height: 84),
            ),
            Positioned(
              left: 20,
              top: 24 + top,
              right: 20,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: AssetImage('assets/images/alisa.png'),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Alisa Selvia Saharani',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Computer Science Student',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: ListTile(
        selected: selected,
        selectedColor: OceanColors.navy,
        selectedTileColor: const Color(0xFFBFE9F8),
        iconColor: OceanColors.navy,
        textColor: OceanColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        onTap: onTap,
      ),
    );
  }
}