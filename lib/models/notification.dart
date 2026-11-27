
/// Model untuk satu notifikasi di dalam aplikasi.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  /// Membuat salinan notifikasi dengan perubahan tertentu.
  AppNotification copyWith({
    bool? read,
  }) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      read: read ?? this.read,
    );
  }
}
