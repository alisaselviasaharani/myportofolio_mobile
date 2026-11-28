import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/course_parser.dart';

void main() {
  group('parseCourses', () {
    test('memisahkan dengan koma dan memangkas spasi', () {
      expect(
        parseCourses(' Algoritma , Basis Data,Struktur Data '),
        ['Algoritma', 'Basis Data', 'Struktur Data'],
      );
    });

    test('membuang isian kosong dan duplikat', () {
      expect(parseCourses('A,, ,a, B'), ['A', 'B']);
    });

    test('null atau kosong menghasilkan daftar kosong', () {
      expect(parseCourses(null), isEmpty);
      expect(parseCourses('  '), isEmpty);
    });
  });

  group('validateCourses', () {
    test('kosong dan wajar dianggap valid', () {
      expect(validateCourses(''), isNull);
      expect(validateCourses('Algoritma, Basis Data'), isNull);
    });

    test('menolak mata kuliah terlalu panjang', () {
      expect(
        validateCourses('a' * 51),
        'Setiap mata kuliah maksimal 50 karakter!',
      );
    });

    test('menolak jumlah berlebih', () {
      final many = List.generate(21, (i) => 'MK$i').join(', ');
      expect(validateCourses(many), 'Maksimal 20 mata kuliah!');
    });
  });
}
