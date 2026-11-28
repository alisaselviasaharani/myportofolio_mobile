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
