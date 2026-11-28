/// Aset gambar institusi yang tersedia di `assets/images/`.
const String uiLogoAsset = 'assets/images/ui_logo.png';
const String uiCampusAsset = 'assets/images/ui_campus.jpg';

/// `true` jika [institution] adalah Universitas Indonesia.
bool isUniversitasIndonesia(String institution) {
  final name = institution.toLowerCase().trim();
  return name == 'ui' || name.contains('universitas indonesia');
}

/// Logo institusi, atau `null` jika belum punya aset.
String? institutionLogoAsset(String institution) =>
    isUniversitasIndonesia(institution) ? uiLogoAsset : null;

/// Foto kampus institusi, atau `null` jika belum punya aset.
String? institutionPhotoAsset(String institution) =>
    isUniversitasIndonesia(institution) ? uiCampusAsset : null;
