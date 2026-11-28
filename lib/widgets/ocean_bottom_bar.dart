import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/favorite_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/profile_screen.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Bottom navigation bar mengambang bergaya laut: Beranda, Portofolio,
/// tombol tambah di tengah, Favorit, dan Profil (dengan label di bawah ikon).
///
/// Beranda membersihkan stack lalu membuka [MyHomePage]; Portofolio,
/// Favorit, dan Profil membuka [EducationListScreen], [FavoriteScreen], dan
/// [ProfileScreen]; tombol tengah membuka lembar pilihan form.
/// Pasang pada `Scaffold` dengan `extendBody: true` agar latar laut terlihat
/// di sekitar bar.
class OceanBottomBar extends StatelessWidget {
  const OceanBottomBar({
    super.key,
    this.homeSelected = false,
    this.portfolioSelected = false,
    this.favoriteSelected = false,
    this.profileSelected = false,
  });

  /// `true` jika bar dipasang di halaman utama (Beranda aktif).
  final bool homeSelected;

  /// `true` jika bar dipasang di halaman portofolio (Portofolio aktif, ungu).
  final bool portfolioSelected;

  /// `true` jika bar dipasang di halaman Favorit.
  final bool favoriteSelected;

  /// `true` jika bar dipasang di halaman Profil.
  final bool profileSelected;

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

  /// Membuka [page] dari menu bar. Stack dikembalikan ke beranda terlebih
  /// dulu agar tombol kembali tetap masuk akal dan stack tidak menumpuk.
  void _openPage(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => route.isFirst,
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
                title: const Text('Add Certification'),
                onTap: () => open(const AchievementFormPage()),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white),
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
              Expanded(
                child: _BarItem(
                  icon: homeSelected ? Icons.home : Icons.home_outlined,
                  label: 'Beranda',
                  selected: homeSelected,
                  onTap: () => _goHome(context),
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: Icons.auto_stories_outlined,
                  label: 'Portofolio',
                  selected: portfolioSelected,
                  onTap: () => _openPage(context, const EducationListScreen()),
                ),
              ),
              Expanded(
                child: Center(
                  child: _AddButton(onTap: () => _showAddSheet(context)),
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: favoriteSelected ? Icons.star : Icons.star_border,
                  label: 'Favorit',
                  selected: favoriteSelected,
                  onTap: () => _openPage(context, const FavoriteScreen()),
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: profileSelected ? Icons.person : Icons.person_outline,
                  label: 'Profil',
                  selected: profileSelected,
                  onTap: () => _openPage(context, const ProfileScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? OceanColors.purpleSelected : OceanColors.navy;
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Tambah',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [OceanColors.teal, OceanColors.deep],
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: OceanColors.deep.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}
