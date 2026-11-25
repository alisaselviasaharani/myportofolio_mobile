import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/validators.dart';

void main() {
  group('FormValidators.username', () {
    test('menolak kosong, hanya spasi, dan terlalu pendek', () {
      expect(FormValidators.username(null), 'Username tidak boleh kosong!');
      expect(FormValidators.username('   '), 'Username tidak boleh kosong!');
      expect(FormValidators.username('ab'), 'Username minimal 3 karakter!');
    });

    test('menolak username terlalu panjang', () {
      expect(
        FormValidators.username('a' * 151),
        'Username maksimal 150 karakter!',
      );
    });

    test('menolak spasi dan simbol yang tidak diizinkan', () {
      const message = 'Username hanya boleh huruf, angka, dan . @ + - _';
      expect(FormValidators.username('ali sa'), message);
      expect(FormValidators.username('alisa!'), message);
    });

    test('menerima huruf, angka, dan . @ + - _', () {
      expect(FormValidators.username('alisa_selvia'), isNull);
      expect(FormValidators.username('alisa.s-1+x@y'), isNull);
    });
  });

  group('FormValidators.password', () {
    test('menolak kosong dan kurang dari 8 karakter', () {
      expect(FormValidators.password(null), 'Kata sandi tidak boleh kosong!');
      expect(FormValidators.password(''), 'Kata sandi tidak boleh kosong!');
      expect(
        FormValidators.password('1234567'),
        'Kata sandi minimal 8 karakter!',
      );
    });

    test('menerima tepat 8 karakter, termasuk spasi', () {
      expect(FormValidators.password('12345678'), isNull);
      expect(FormValidators.password('a b c d e'), isNull);
    });

    test('batas minimal bisa diubah', () {
      expect(
        FormValidators.password('abc', minLength: 4),
        'Kata sandi minimal 4 karakter!',
      );
      expect(FormValidators.password('abcd', minLength: 4), isNull);
    });
  });

  group('FormValidators.confirmPassword', () {
    test('menolak kosong', () {
      expect(
        FormValidators.confirmPassword('', 'rahasia123'),
        'Konfirmasi kata sandi tidak boleh kosong!',
      );
      expect(
        FormValidators.confirmPassword(null, 'rahasia123'),
        'Konfirmasi kata sandi tidak boleh kosong!',
      );
    });

    test('menolak yang berbeda, termasuk beda huruf besar', () {
      expect(
        FormValidators.confirmPassword('rahasia124', 'rahasia123'),
        'Konfirmasi kata sandi tidak sama!',
      );
      expect(
        FormValidators.confirmPassword('Rahasia123', 'rahasia123'),
        'Konfirmasi kata sandi tidak sama!',
      );
    });

    test('menerima yang sama persis', () {
      expect(FormValidators.confirmPassword('rahasia123', 'rahasia123'), isNull);
    });
  });
}
