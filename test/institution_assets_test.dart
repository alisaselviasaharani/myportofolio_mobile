import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/institution_assets.dart';

void main() {
  test('Universitas Indonesia dikenali dengan berbagai penulisan', () {
    expect(isUniversitasIndonesia('Universitas Indonesia'), isTrue);
    expect(isUniversitasIndonesia('  universitas indonesia, Depok '), isTrue);
    expect(isUniversitasIndonesia('UI'), isTrue);
  });

  test('institusi lain tidak memakai aset UI', () {
    expect(isUniversitasIndonesia('Universitas Gadjah Mada'), isFalse);
    expect(isUniversitasIndonesia('Quito School'), isFalse);
    expect(institutionLogoAsset('SMA Negeri 8 Jakarta'), isNull);
    expect(institutionPhotoAsset('SMA Negeri 8 Jakarta'), isNull);
  });

  test('UI mendapat logo dan foto kampus', () {
    expect(institutionLogoAsset('Universitas Indonesia'), uiLogoAsset);
    expect(institutionPhotoAsset('Universitas Indonesia'), uiCampusAsset);
  });
}
