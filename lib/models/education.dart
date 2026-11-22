/// Jenjang pendidikan yang bisa dipilih pada form.
enum DegreeLevel {
  highSchool('SMA/SMK'),
  diploma('D3'),
  bachelor('S1'),
  master('S2'),
  doctor('S3');

  const DegreeLevel(this.label);

  /// Teks yang ditampilkan kepada pengguna.
  final String label;
}

/// Data satu riwayat pendidikan.
///
/// Field mengikuti model Django `Education`: `institution`, `degree`,
/// `period`, dan `website` (opsional).
class Education {
  const Education({
    required this.institution,
    required this.degree,
    required this.startDate,
    required this.endDate,
    required this.period,
    this.website = '',
  });

  /// Nama institusi (maks. 100 karakter pada model).
  final String institution;

  /// Jenjang dan jurusan, misalnya `S1 - Ilmu Komputer` (maks. 100 karakter).
  final String degree;

  final DateTime startDate;
  final DateTime endDate;

  /// Periode dalam bentuk teks (maks. 50 karakter pada model).
  final String period;

  /// URL website institusi (opsional, maks. 255 karakter pada model).
  final String website;
}
