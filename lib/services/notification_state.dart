import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/models/notification.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';

/// Mengelola daftar notifikasi selama sesi aplikasi.
class NotificationState extends ChangeNotifier {
  NotificationState(this._settings);

  final AppSettings _settings;

  final List<AppNotification> _items = [];

  int _nextId = 1;

  /// Daftar notifikasi terbaru berada di urutan pertama.
  List<AppNotification> get items => List.unmodifiable(_items);

  /// Jumlah notifikasi yang belum dibaca.
  int get unreadCount => _items.where((item) => !item.read).length;

  /// Memeriksa apakah daftar notifikasi kosong.
  bool get isEmpty => _items.isEmpty;

  /// Menambahkan notifikasi baru.
  /// Mengembalikan false jika notifikasi sedang dimatikan.
  bool add(String title, String body) {
    if (!_settings.notificationsEnabled) {
      return false;
    }

    final notification = AppNotification(
      id: _nextId++,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );

    _items.insert(0, notification);

    notifyListeners();

    return true;
  }

  /// Menandai satu notifikasi sebagai sudah dibaca.
  void markRead(int id) {
    final index = _items.indexWhere((item) => item.id == id);

    if (index == -1) return;
    if (_items[index].read) return;

    _items[index] = _items[index].copyWith(read: true);

    notifyListeners();
  }

  /// Menandai semua notifikasi sebagai sudah dibaca.
  void markAllRead() {
    if (unreadCount == 0) return;

    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(read: true);
    }

    notifyListeners();
  }

  /// Menghapus satu notifikasi berdasarkan ID.
  void remove(int id) {
    final previousLength = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length != previousLength) {
      notifyListeners();
    }
  }

  /// Menghapus seluruh notifikasi.
  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
