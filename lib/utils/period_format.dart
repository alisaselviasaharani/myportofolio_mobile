/// Pemformat tanggal/periode sederhana (tanpa paket `intl`).
const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Mengubah [date] menjadi teks seperti `5 Nov 2026`.
String formatDate(DateTime date) {
  return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
}

/// Mengubah [date] menjadi teks bulan-tahun seperti `Sep 2023`.
String formatMonthYear(DateTime date) {
  return '${_monthNames[date.month - 1]} ${date.year}';
}

/// Menyusun teks periode dari [start] dan [end] (opsional).
///
/// Jika [end] kosong atau jatuh pada hari yang sama dengan [start], hasilnya
/// satu tanggal saja. Hasilnya selalu jauh di bawah batas 50 karakter pada
/// field `period` di model Django.
String formatPeriod(DateTime start, DateTime? end) {
  if (end == null) {
    return formatDate(start);
  }
  final sameDay =
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;
  if (sameDay) {
    return formatDate(start);
  }
  return '${formatDate(start)} - ${formatDate(end)}';
}

/// Periode bulan-tahun untuk daftar pendidikan, misalnya `Sep 2023 – Jun 2027`.
///
/// Jika [end] kosong: `Sep 2023 – Sekarang` saat [isCurrent], atau hanya
/// `Sep 2023` jika sudah tidak aktif.
String formatMonthPeriod(
  DateTime start,
  DateTime? end, {
  bool isCurrent = false,
}) {
  final from = formatMonthYear(start);
  if (end != null) {
    return '$from – ${formatMonthYear(end)}';
  }
  return isCurrent ? '$from – Sekarang' : from;
}

/// Membaca kembali teks hasil [formatPeriod], misalnya `5 Nov 2026` atau
/// `5 Nov 2026 - 10 Des 2026`. Mengembalikan `null` jika formatnya tidak
/// dikenali (misalnya periode yang diketik manual di Django).
({DateTime start, DateTime? end})? parsePeriod(String text) {
  final parts = text.trim().split(RegExp(r'\s+-\s+'));
  if (parts.isEmpty || parts.length > 2) {
    return null;
  }
  final start = _parseDate(parts.first);
  if (start == null) {
    return null;
  }
  if (parts.length == 1) {
    return (start: start, end: null);
  }
  final end = _parseDate(parts.last);
  if (end == null) {
    return null;
  }
  return (start: start, end: end);
}

DateTime? _parseDate(String text) {
  final match = RegExp(r'^(\d{1,2}) (\S+) (\d{4})$').firstMatch(text.trim());
  if (match == null) {
    return null;
  }
  final month = _monthNames.indexOf(match.group(2)!);
  if (month == -1) {
    return null;
  }
  final day = int.parse(match.group(1)!);
  final date = DateTime(int.parse(match.group(3)!), month + 1, day);
  // Menolak tanggal yang tidak ada (misalnya 31 Feb) karena DateTime menggulung.
  return date.day == day ? date : null;
}
