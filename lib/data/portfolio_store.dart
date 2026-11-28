import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/models/achievement.dart';
import 'package:myportofolio_mobile/models/education.dart';

/// Penyimpanan data portofolio di memori (hilang saat aplikasi ditutup).
///
/// Memakai [ValueNotifier] sehingga halaman yang mendengarkannya (misalnya
/// bagian "My Portfolio" di beranda) otomatis diperbarui saat data berubah.
/// Nantinya diganti dengan pemanggilan REST API Django.
class PortfolioStore {
  PortfolioStore._();

  /// Satu instance bersama untuk seluruh aplikasi.
  static final PortfolioStore instance = PortfolioStore._();

  final ValueNotifier<List<Education>> educations = ValueNotifier(const []);
  final ValueNotifier<List<Achievement>> achievements = ValueNotifier(const []);

  /// Pendidikan yang ditandai favorit (bintang di halaman detail).
  final ValueNotifier<List<Education>> favorites = ValueNotifier(const []);

  /// Jumlah experience yang sudah disimpan (model Experience belum dibuat).
  final ValueNotifier<int> experienceCount = ValueNotifier(0);

  void addEducation(Education education) {
    educations.value = [...educations.value, education];
  }

  /// Mengganti [old] dengan [updated] pada posisi yang sama.
  /// Tidak melakukan apa-apa jika [old] tidak ada di daftar.
  void updateEducation(Education old, Education updated) {
    // Status favorit ikut berpindah ke versi yang baru.
    final favIndex = favorites.value.indexOf(old);
    if (favIndex != -1) {
      final favs = [...favorites.value];
      favs[favIndex] = updated;
      favorites.value = favs;
    }
    final index = educations.value.indexOf(old);
    if (index == -1) {
      return;
    }
    final list = [...educations.value];
    list[index] = updated;
    educations.value = list;
  }

  bool isFavorite(Education education) => favorites.value.contains(education);

  /// Menambah [education] ke favorit, atau menghapusnya jika sudah ada.
  void toggleFavorite(Education education) {
    favorites.value = isFavorite(education)
        ? favorites.value.where((e) => e != education).toList()
        : [...favorites.value, education];
  }

  void addAchievement(Achievement achievement) {
    achievements.value = [...achievements.value, achievement];
  }

  void addExperience() {
    experienceCount.value = experienceCount.value + 1;
  }

  /// Mengosongkan semua data (dipakai pada test).
  void clear() {
    educations.value = const [];
    favorites.value = const [];
    achievements.value = const [];
    experienceCount.value = 0;
  }
}
