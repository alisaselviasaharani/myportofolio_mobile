/// Data akun yang login, dari `GET /api/v1/auth/me/`.
class UserProfile {
  const UserProfile({
    required this.username,
    required this.email,
    required this.fullName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
    );
  }

  final String username;
  final String email;
  final String fullName;

  /// Nama yang ditampilkan: nama lengkap, atau username jika kosong.
  String get displayName => fullName.isEmpty ? username : fullName;
}
