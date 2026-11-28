/// Mengubah teks "Algoritma, Basis Data" menjadi daftar mata kuliah.
///
/// Dipisah koma, spasi tepi dipangkas, isian kosong dibuang, dan duplikat
/// (tanpa membedakan huruf besar/kecil) hanya diambil sekali.
List<String> parseCourses(String? raw) {
  if (raw == null) {
    return const [];
  }
  final seen = <String>{};
  final result = <String>[];
  for (final part in raw.split(',')) {
    final name = part.trim();
    if (name.isEmpty) {
      continue;
    }
    if (seen.add(name.toLowerCase())) {
      result.add(name);
    }
  }
  return result;
}

/// Validator untuk isian mata kuliah (opsional): batas jumlah dan panjang.
String? validateCourses(String? raw, {int maxItems = 20, int maxLength = 50}) {
  final courses = parseCourses(raw);
  if (courses.length > maxItems) {
    return 'Maksimal $maxItems mata kuliah!';
  }
  if (courses.any((course) => course.length > maxLength)) {
    return 'Setiap mata kuliah maksimal $maxLength karakter!';
  }
  return null;
}
