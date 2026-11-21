/// Fungsi validasi murni (tanpa dependensi Flutter) untuk formulir.
///
/// Setiap fungsi mengembalikan pesan error, atau `null` jika input valid,
/// sehingga bisa dipasang langsung pada `validator` milik `TextFormField`
/// dan diuji tanpa menjalankan UI.
class FormValidators {
  const FormValidators._();

  /// Isian wajib: tidak boleh kosong, tidak boleh hanya spasi, dan tidak
  /// boleh melebihi [maxLength] (jika diberikan).
  static String? requiredText(
    String? value, {
    required String fieldName,
    int? maxLength,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    if (maxLength != null && text.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter!';
    }
    return null;
  }

  /// URL opsional: boleh kosong, tetapi jika diisi harus berupa URL
  /// `http`/`https` dengan host (mengandung titik) dan tanpa spasi.
  static String? optionalUrl(
    String? value, {
    required String fieldName,
    int maxLength = 500,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    if (text.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter!';
    }
    final uri = Uri.tryParse(text);
    final isValid = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.') &&
        !text.contains(' ');
    if (!isValid) {
      return '$fieldName harus berupa URL valid (diawali http:// atau https://)!';
    }
    return null;
  }

  /// Tanggal wajib dipilih.
  static String? requiredDate(DateTime? date, {required String fieldName}) {
    if (date == null) {
      return '$fieldName harus dipilih!';
    }
    return null;
  }

  /// Urutan tanggal: [end] (opsional) tidak boleh sebelum [start].
  /// Tanggal yang sama dianggap valid.
  static String? dateOrder(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return null;
    }
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    if (endDay.isBefore(startDay)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }
}
