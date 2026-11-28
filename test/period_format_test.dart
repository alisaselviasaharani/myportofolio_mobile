import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';

void main() {
  test('formatDate memakai singkatan bulan Indonesia', () {
    expect(formatDate(DateTime(2026, 11, 5)), '5 Nov 2026');
    expect(formatDate(DateTime(2026, 5, 17)), '17 Mei 2026');
    expect(formatDate(DateTime(2026, 8, 1)), '1 Agu 2026');
  });

  group('formatPeriod', () {
    final start = DateTime(2026, 11, 5);

    test('tanpa tanggal selesai hanya menampilkan satu tanggal', () {
      expect(formatPeriod(start, null), '5 Nov 2026');
    });

    test(
      'tanggal selesai sama dengan mulai hanya menampilkan satu tanggal',
      () {
        expect(formatPeriod(start, DateTime(2026, 11, 5, 18)), '5 Nov 2026');
      },
    );

    test('rentang tanggal digabung dengan tanda hubung', () {
      expect(
        formatPeriod(start, DateTime(2027, 1, 20)),
        '5 Nov 2026 - 20 Jan 2027',
      );
    });

    test('hasil tidak melebihi 50 karakter (batas field period di Django)', () {
      final text = formatPeriod(DateTime(2026, 12, 28), DateTime(2036, 12, 28));
      expect(text.length, lessThanOrEqualTo(50));
    });
  });

  group('formatMonthPeriod', () {
    final start = DateTime(2023, 9, 1);

    test('dengan tanggal selesai memakai bulan-tahun dan en dash', () {
      expect(
        formatMonthPeriod(start, DateTime(2027, 6, 1)),
        'Sep 2023 – Jun 2027',
      );
    });

    test('masih aktif tanpa tanggal selesai menampilkan Sekarang', () {
      expect(formatMonthPeriod(start, null, isCurrent: true), 'Sep 2023 – Sekarang');
    });

    test('tidak aktif tanpa tanggal selesai hanya bulan mulai', () {
      expect(formatMonthPeriod(start, null), 'Sep 2023');
    });
  });
}
