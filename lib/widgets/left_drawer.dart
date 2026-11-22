import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';

/// Tujuan pada drawer; dipakai untuk menandai item yang sedang aktif.
enum DrawerDestination { home, experience, education, achievement }

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
      backgroundColor: OceanColors.foam,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [OceanColors.deep, OceanColors.teal],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text('🐙', style: TextStyle(fontSize: 30)),
                ),
                SizedBox(height: 12),
                Text(
                  'Alisa Selvia Saharani',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Computer Science Student',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _DrawerTile(
            icon: Icons.home_outlined,
            title: 'Home',
            selected: selected == DrawerDestination.home,
            // Navigasi ke halaman utama portofolio
            onTap: () => _go(context, MyHomePage()),
          ),
          _DrawerTile(
            icon: Icons.add_circle_outline,
            title: 'Add Experience',
            selected: selected == DrawerDestination.experience,
            onTap: () => _go(context, const ExperienceFormPage()),
          ),
          _DrawerTile(
            icon: Icons.school_outlined,
            title: 'Add Education',
            selected: selected == DrawerDestination.education,
            onTap: () => _go(context, const EducationFormPage()),
          ),
          _DrawerTile(
            icon: Icons.emoji_events_outlined,
            title: 'Add Achievement',
            selected: selected == DrawerDestination.achievement,
            onTap: () => _go(context, const AchievementFormPage()),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(),
          ),
          _DrawerTile(
            icon: Icons.person_outline,
            title: 'About Me',
            selected: false,
            onTap: () => _comingSoon(context, 'About Me'),
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
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedColor: OceanColors.deep,
        selectedTileColor: OceanColors.aqua,
        shape: const StadiumBorder(),
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
