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
  final ValueNotifier<List<Achievement>> achievements =
      ValueNotifier(const []);

  /// Jumlah experience yang sudah disimpan (model Experience belum dibuat).
  final ValueNotifier<int> experienceCount = ValueNotifier(0);

  /// Jumlah project yang sudah disimpan (model Project dibuat di tahap form).
  final ValueNotifier<int> projectCount = ValueNotifier(0);

  void addProject() {
    projectCount.value = projectCount.value + 1;
  }

  void addEducation(Education education) {
    educations.value = [...educations.value, education];
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
    achievements.value = const [];
    experienceCount.value = 0;
    projectCount.value = 0;
  }
}
