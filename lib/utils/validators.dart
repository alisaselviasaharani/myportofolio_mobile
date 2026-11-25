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
    final isValid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.') &&
        !text.contains(' ');
    if (!isValid) {
      return '$fieldName harus berupa URL valid (diawali http:// atau https://)!';
    }
    return null;
  }

  /// URL wajib: tidak boleh kosong, lalu harus lolos aturan [optionalUrl].
  static String? requiredUrl(
    String? value, {
    required String fieldName,
    int maxLength = 500,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    return optionalUrl(value, fieldName: fieldName, maxLength: maxLength);
  }

  /// Email wajib: tidak boleh kosong dan harus berformat `nama@domain.tld`.
  static String? requiredEmail(String? value, {int maxLength = 254}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email tidak boleh kosong!';
    }
    if (text.length > maxLength) {
      return 'Email maksimal $maxLength karakter!';
    }
    final isValid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text);
    if (!isValid) {
      return 'Format email tidak valid!';
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

  /// Username wajib: 3 sampai 150 karakter, hanya huruf, angka, dan
  /// `. @ + - _` (aturan username bawaan Django).
  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Username tidak boleh kosong!';
    }
    if (text.length < 3) {
      return 'Username minimal 3 karakter!';
    }
    if (text.length > 150) {
      return 'Username maksimal 150 karakter!';
    }
    if (!RegExp(r'^[\w.@+-]+$').hasMatch(text)) {
      return 'Username hanya boleh huruf, angka, dan . @ + - _';
    }
    return null;
  }

  /// Kata sandi wajib: tidak boleh kosong dan minimal [minLength] karakter.
  /// Spasi di tepi tidak dipangkas karena bagian dari kata sandi.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong!';
    }
    if (value.length < minLength) {
      return 'Kata sandi minimal $minLength karakter!';
    }
    return null;
  }

  /// Konfirmasi kata sandi: wajib diisi dan harus sama dengan [original].
  static String? confirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong!';
    }
    if (value != original) {
      return 'Konfirmasi kata sandi tidak sama!';
    }
    return null;
  }
}
