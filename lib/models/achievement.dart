/// Kategori achievement, mengikuti `ACHIEVEMENTS_CHOICES` pada model Django
/// `Achievements` di website myportofolio.
enum AchievementCategory {
  academic('Academic'),
  competition('Competition'),
  certification('Certification'),
  award('Award'),
  other('Other');

  const AchievementCategory(this.label);

  /// Teks yang ditampilkan kepada pengguna.
  final String label;
}

/// Data satu achievement (penghargaan/sertifikasi).
///
/// Field mengikuti model Django `Achievements`: `title`, `period`,
/// `description`, `category`, dan `achievements_image_url`.
class Achievement {
  const Achievement({
    required this.title,
    required this.period,
    required this.description,
    required this.category,
    this.imageUrl = '',
  });

  /// Nama penghargaan (maks. 255 karakter pada model).
  final String title;

  /// Periode dalam bentuk teks, misalnya `15 Nov 2026 - 20 Jan 2027`.
  final String period;

  /// Deskripsi penghargaan.
  final String description;

  /// Kategori penghargaan.
  final AchievementCategory category;

  /// URL gambar penghargaan (opsional, maks. 500 karakter pada model).
  final String imageUrl;
}
