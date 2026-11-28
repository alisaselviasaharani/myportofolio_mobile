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

  test('SMAN 65 dikenali dengan berbagai penulisan', () {
    expect(isSman65('SMAN 65 Jakarta'), isTrue);
    expect(isSman65('SMA Negeri 65 Jakarta'), isTrue);
    expect(isSman65('sma 65'), isTrue);
    expect(isSman65('SMA Negeri 165 Jakarta'), isFalse);
    expect(isSman65('SMA Negeri 8 Jakarta'), isFalse);
  });

  test('SMAN 65 mendapat logo dan foto gedung', () {
    expect(institutionLogoAsset('SMA Negeri 65 Jakarta'), sma65LogoAsset);
    expect(institutionPhotoAsset('SMAN 65'), sma65PhotoAsset);
  });

  test('MTsN 12 mendapat logo', () {
    expect(institutionLogoAsset('MTsN 12 Jakarta'), mtsn12LogoAsset);
    expect(institutionPhotoAsset('MTsN 12 Jakarta'), isNull);
  });
}
