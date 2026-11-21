import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/validators.dart';

void main() {
  group('FormValidators.requiredText', () {
    test('menolak null, string kosong, dan hanya spasi', () {
      expect(
        FormValidators.requiredText(null, fieldName: 'Nama'),
        'Nama tidak boleh kosong!',
      );
      expect(
        FormValidators.requiredText('', fieldName: 'Nama'),
        'Nama tidak boleh kosong!',
      );
      expect(
        FormValidators.requiredText('   \n\t ', fieldName: 'Nama'),
        'Nama tidak boleh kosong!',
      );
    });

    test('menerima teks biasa dan teks dengan spasi di tepi', () {
      expect(FormValidators.requiredText('Juara 1', fieldName: 'Nama'), isNull);
      expect(FormValidators.requiredText('  Juara 1  ', fieldName: 'Nama'),
          isNull);
    });

    test('menolak teks yang melebihi batas panjang', () {
      expect(
        FormValidators.requiredText('a' * 11, fieldName: 'Nama', maxLength: 10),
        'Nama maksimal 10 karakter!',
      );
      expect(
        FormValidators.requiredText('a' * 10, fieldName: 'Nama', maxLength: 10),
        isNull,
      );
    });
  });

  group('FormValidators.optionalUrl', () {
    test('kosong atau spasi saja dianggap valid (opsional)', () {
      expect(FormValidators.optionalUrl(null, fieldName: 'URL'), isNull);
      expect(FormValidators.optionalUrl('', fieldName: 'URL'), isNull);
      expect(FormValidators.optionalUrl('   ', fieldName: 'URL'), isNull);
    });

    test('menerima URL http dan https yang valid', () {
      expect(
        FormValidators.optionalUrl('https://contoh.com/a.png', fieldName: 'URL'),
        isNull,
      );
      expect(
        FormValidators.optionalUrl(
          'http://drive.google.com/thumbnail?id=1&sz=w1000',
          fieldName: 'URL',
        ),
        isNull,
      );
    });

    test('menolak URL tanpa skema, skema lain, tanpa host, atau berspasi', () {
      for (final bad in [
        'bukan-url',
        'www.google.com',
        'ftp://contoh.com/a.png',
        'https://',
        'https://localhost',
        'https://contoh .com',
      ]) {
        expect(
          FormValidators.optionalUrl(bad, fieldName: 'URL'),
          isNotNull,
          reason: '"$bad" seharusnya ditolak',
        );
      }
    });

    test('menolak URL yang melebihi batas panjang', () {
      final longUrl = 'https://contoh.com/${'a' * 500}';
      expect(
        FormValidators.optionalUrl(longUrl, fieldName: 'URL', maxLength: 500),
        'URL maksimal 500 karakter!',
      );
    });
  });

  group('FormValidators.requiredDate', () {
    test('menolak null dan menerima tanggal', () {
      expect(
        FormValidators.requiredDate(null, fieldName: 'Tanggal mulai'),
        'Tanggal mulai harus dipilih!',
      );
      expect(
        FormValidators.requiredDate(DateTime(2026, 11, 1),
            fieldName: 'Tanggal mulai'),
        isNull,
      );
    });
  });

  group('FormValidators.dateOrder', () {
    final start = DateTime(2026, 11, 10);

    test('valid jika salah satu tanggal kosong', () {
      expect(FormValidators.dateOrder(null, null), isNull);
      expect(FormValidators.dateOrder(start, null), isNull);
      expect(FormValidators.dateOrder(null, start), isNull);
    });

    test('menolak tanggal selesai sebelum tanggal mulai', () {
      expect(
        FormValidators.dateOrder(start, DateTime(2026, 11, 9)),
        'Tanggal selesai tidak boleh sebelum tanggal mulai!',
      );
    });

    test('menerima tanggal yang sama dan tanggal sesudahnya', () {
      expect(FormValidators.dateOrder(start, DateTime(2026, 11, 10, 23)), isNull);
      expect(FormValidators.dateOrder(start, DateTime(2027, 1, 1)), isNull);
    });
  });
}
