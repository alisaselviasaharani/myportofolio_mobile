import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/utils/snackbar.dart';

/// Bottom navigation bar bergaya laut: Beranda, Statistik, tombol tambah di
/// tengah, Tersimpan, dan Profil.
///
/// Beranda membersihkan stack lalu membuka [MyHomePage]; tombol tengah
/// membuka lembar pilihan form. Menu lain masih placeholder.
class OceanBottomBar extends StatelessWidget {
  const OceanBottomBar({super.key, this.homeSelected = false});

  /// `true` jika bar dipasang di halaman utama (ikon Beranda aktif).
  final bool homeSelected;

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

  void _showAddSheet(BuildContext context) {
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
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tambah data',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    showInfoSnackBar(context, '$label akan hadir di tahap berikutnya.');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BarIcon(
                icon: homeSelected ? Icons.home : Icons.home_outlined,
                tooltip: 'Beranda',
                selected: homeSelected,
                onPressed: () => _goHome(context),
              ),
              _BarIcon(
                icon: Icons.bar_chart,
                tooltip: 'Statistik',
                onPressed: () => _comingSoon(context, 'Statistik'),
              ),
              IconButton.filled(
                tooltip: 'Tambah',
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: OceanColors.seaGreen,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(50, 50),
                ),
                onPressed: () => _showAddSheet(context),
              ),
              _BarIcon(
                icon: Icons.bookmark_border,
                tooltip: 'Tersimpan',
                onPressed: () => _comingSoon(context, 'Tersimpan'),
              ),
              _BarIcon(
                icon: Icons.person_outline,
                tooltip: 'Profil',
                onPressed: () => _comingSoon(context, 'Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: selected ? OceanColors.deep : Colors.black45),
      onPressed: onPressed,
    );
  }
}
