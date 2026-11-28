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

  /// Menghapus [education] dari daftar dan favorit (dicocokkan lewat `id`
  /// jika ada, selain itu lewat objeknya).
  void removeEducation(Education education) {
    bool same(Education e) =>
        identical(e, education) ||
        (education.id != null && e.id == education.id);
    educations.value = educations.value.where((e) => !same(e)).toList();
    favorites.value = favorites.value.where((e) => !same(e)).toList();
  }

  /// Mengganti seluruh daftar dengan data dari Django.
  ///
  /// Django hanya menyimpan institusi, jenjang/jurusan, periode, logo, dan
  /// website. Field yang hanya ada di aplikasi (deskripsi, mata kuliah,
  /// tanggal, status) dipertahankan dari data lokal dengan `id` yang sama
  /// selama periodenya tidak berubah. Favorit ikut dipetakan lewat `id`.
  void replaceEducations(List<Education> fetched) {
    final local = {
      for (final e in educations.value)
        if (e.id != null) e.id!: e,
    };
    final merged = [
      for (final server in fetched) _withLocalExtras(server, local[server.id]),
    ];
    final byId = {
      for (final e in merged)
        if (e.id != null) e.id!: e,
    };
    final favs = <Education>[];
    for (final fav in favorites.value) {
      if (fav.id == null) {
        favs.add(fav);
      } else if (byId[fav.id] != null) {
        favs.add(byId[fav.id]!);
      }
    }
    educations.value = merged;
    favorites.value = favs;
  }

  static Education _withLocalExtras(Education server, Education? local) {
    if (local == null || local.period != server.period) {
      return server;
    }
    return server.copyWith(
      isCurrent: local.isCurrent,
      description: local.description,
      courses: local.courses,
      startDate: local.startDate,
      endDate: local.endDate,
    );
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

  /// Mengurangi jumlah experience (tidak pernah di bawah nol).
  void removeExperience() {
    if (experienceCount.value > 0) {
      experienceCount.value = experienceCount.value - 1;
    }
  }

  /// Menghapus [achievement] (dicocokkan lewat `id` jika ada).
  void removeAchievement(Achievement achievement) {
    achievements.value = achievements.value
        .where(
          (a) =>
              !(identical(a, achievement) ||
                  (achievement.id != null && a.id == achievement.id)),
        )
        .toList();
  }

  /// Mengosongkan semua data (dipakai pada test).
  void clear() {
    educations.value = const [];
    favorites.value = const [];
    achievements.value = const [];
    experienceCount.value = 0;
  }
}
