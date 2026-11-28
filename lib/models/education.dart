/// Jenjang pendidikan yang bisa dipilih pada form.
enum DegreeLevel {
  junior('SMP', 'SMP'),
  highSchool('SMA', 'SMA/SMK'),
  diploma('D3', 'D3 (Diploma)'),
  bachelor('S1', 'S1 (Sarjana)'),
  master('S2', 'S2 (Magister)'),
  doctor('S3', 'S3 (Doktor)');

  const DegreeLevel(this.label, this.fullLabel);

  /// Singkatan yang dipakai di daftar, misalnya `S1`.
  final String label;

  /// Teks lengkap untuk dropdown dan halaman detail, misalnya `S1 (Sarjana)`.
  final String fullLabel;

  /// Mencari jenjang dari singkatan, misalnya `S1`. Mengenali `MTS` sebagai SMP.
  /// Mengembalikan `null` jika tidak dikenali.
  static DegreeLevel? fromLabel(String text) {
    final upper = text.trim().toUpperCase();
    if (upper == 'MTS') {
      return DegreeLevel.junior;
    }
    for (final level in DegreeLevel.values) {
      if (level.label == upper) {
        return level;
      }
    }
    return null;
  }
}

/// Data satu riwayat pendidikan.
///
/// Field `id`, `institution`, `degree`, `period`, `logo`, dan `website`
/// mengikuti model Django `Education` (REST API). Field lain (`level`,
/// `major`, `isCurrent`, `description`, `courses`, `startDate`, `endDate`)
/// dipakai tampilan daftar, detail, dan form.
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.degree,
    required this.period,
    this.startDate,
    this.endDate,
    this.logo = '',
    this.website = '',
    this.level = DegreeLevel.bachelor,
    this.major = '',
    this.isCurrent = false,
    this.description = '',
    this.courses = const [],
  });

  final String? id;

  /// Nama institusi (maks. 100 karakter pada model).
  final String institution;

  /// Jenjang dan jurusan, misalnya `S1 - Ilmu Komputer` (maks. 100 karakter).
  final String degree;

  /// Periode dalam bentuk teks (maks. 50 karakter pada model).
  final String period;

  /// Tanggal mulai. Kosong untuk data dari API yang hanya punya teks periode.
  final DateTime? startDate;

  /// Tanggal selesai (atau perkiraan lulus). Kosong jika belum ditentukan.
  final DateTime? endDate;

  final String logo;

  /// URL website institusi (opsional, maks. 255 karakter pada model).
  final String website;

  final DegreeLevel level;

  /// Program studi / jurusan.
  final String major;

  /// `true` jika masih berstatus mahasiswa/siswa (status "Aktif").
  final bool isCurrent;

  final String description;

  /// Mata kuliah relevan.
  final List<String> courses;

  /// Status yang ditampilkan: `Aktif` atau `Lulus`.
  String get statusLabel => isCurrent ? 'Aktif' : 'Lulus';

  /// Teks jenjang dan program studi, misalnya `S1 – Ilmu Komputer`.
  /// Jika program studi kosong, dipakai [degree].
  String get subtitle => major.isEmpty ? degree : '${level.label} – $major';

  factory Education.fromJson(Map<String, dynamic> json) {
    final degree = json['degree']?.toString() ?? '';
    // Format degree dari form: "S1 - Ilmu Komputer".
    final separator = degree.indexOf(' - ');
    final level = separator == -1
        ? DegreeLevel.fromLabel(degree)
        : DegreeLevel.fromLabel(degree.substring(0, separator));
    final major = separator == -1 ? '' : degree.substring(separator + 3);
    return Education(
      id: json['id']?.toString(),
      institution: json['institution']?.toString() ?? '',
      degree: degree,
      period: json['period']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      level: level ?? DegreeLevel.bachelor,
      major: major,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'period': period,
      'logo': logo,
      'website': website,
    };
  }
}
