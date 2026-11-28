import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/period_format.dart';

void main() {
  group('parsePeriod', () {
    test('membaca satu tanggal', () {
      final result = parsePeriod('5 Nov 2026');
      expect(result?.start, DateTime(2026, 11, 5));
      expect(result?.end, isNull);
    });

    test('membaca rentang tanggal hasil formatPeriod', () {
      final start = DateTime(2025, 1, 3);
      final end = DateTime(2025, 12, 20);
      final result = parsePeriod(formatPeriod(start, end));
      expect(result?.start, start);
      expect(result?.end, end);
    });

    test('mengembalikan null untuk format yang tidak dikenal', () {
      expect(parsePeriod(''), isNull);
      expect(parsePeriod('Jan 2025 - Des 2025'), isNull);
      expect(parsePeriod('kemarin'), isNull);
      expect(parsePeriod('31 Feb 2026'), isNull);
      expect(parsePeriod('5 Nov 2026 - besok'), isNull);
    });
  });
}
