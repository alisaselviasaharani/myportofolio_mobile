/// Aset gambar institusi yang tersedia di `assets/images/`.
const String uiLogoAsset = 'assets/images/ui_logo.png';
const String uiCampusAsset = 'assets/images/ui_campus.jpg';
const String sma65LogoAsset = 'assets/images/sma65_logo.png';
const String sma65PhotoAsset = 'assets/images/sma65_building.jpg';
const String mtsn12LogoAsset = 'assets/images/mtsn12_logo.png';

/// `true` jika [institution] adalah Universitas Indonesia.
bool isUniversitasIndonesia(String institution) {
  final name = institution.toLowerCase().trim();
  return name == 'ui' || name.contains('universitas indonesia');
}

/// `true` jika [institution] adalah SMA Negeri 65 Jakarta.
///
/// Mengenali penulisan seperti "SMAN 65", "SMA Negeri 65 Jakarta", atau
/// "SMA 65". Angka dicocokkan utuh agar "SMA Negeri 165" tidak ikut cocok.
bool isSman65(String institution) {
  final name = institution.toLowerCase().trim();
  return RegExp(r'\bsma(n|\s+negeri)?\s*65\b').hasMatch(name);
}

/// `true` jika [institution] adalah MTs Negeri 12 Jakarta.
bool isMtsn12(String institution) {
  final name = institution.toLowerCase().trim();
  return RegExp(r'\b(mtsn|mts\s+negeri|madrasah\s+tsanawiyah\s+negeri)\s*12\b')
      .hasMatch(name);
}

/// Logo institusi, atau `null` jika belum punya aset.
String? institutionLogoAsset(String institution) {
  if (isUniversitasIndonesia(institution)) return uiLogoAsset;
  if (isSman65(institution)) return sma65LogoAsset;
  if (isMtsn12(institution)) return mtsn12LogoAsset;
  return null;
}

/// Foto/latar institusi, atau `null` jika belum punya aset.
String? institutionPhotoAsset(String institution) {
  if (isUniversitasIndonesia(institution)) return uiCampusAsset;
  if (isSman65(institution)) return sma65PhotoAsset;
  return null;
}
