
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/notification_state.dart';

void main() {
  group('AppSettings', () {
    test('nilai awal bahasa, tema, dan notifikasi benar', () {
      final settings = AppSettings();

      expect(settings.language, AppLanguage.id);
      expect(settings.themeMode, AppThemeMode.light);
      expect(settings.notificationsEnabled, isTrue);
    });

    test('setLanguage memperbarui bahasa', () {
      final settings = AppSettings();

      settings.setLanguage(AppLanguage.en);

      expect(settings.language, AppLanguage.en);
    });

    test('setThemeMode memperbarui tema', () {
      final settings = AppSettings();

      settings.setThemeMode(AppThemeMode.dark);

      expect(settings.themeMode, AppThemeMode.dark);
    });

    test('setNotificationsEnabled memperbarui status', () {
      final settings = AppSettings();

      settings.setNotificationsEnabled(false);

      expect(settings.notificationsEnabled, isFalse);
    });

    test('listener hanya dipanggil ketika nilai berubah', () {
      final settings = AppSettings();
      var notified = 0;

      settings.addListener(() {
        notified++;
      });

      settings.setThemeMode(AppThemeMode.dark);
      expect(notified, 1);

      settings.setThemeMode(AppThemeMode.dark);
      expect(notified, 1);

      settings.setNotificationsEnabled(false);
      expect(notified, 2);

      settings.setNotificationsEnabled(false);
      expect(notified, 2);
    });
  });

  group('NotificationState', () {
    test('notifikasi baru berada di urutan pertama', () {
      final state = NotificationState(AppSettings());

      state.add('Pertama', 'Isi pertama');
      state.add('Kedua', 'Isi kedua');

      expect(
        state.items.map((item) => item.title).toList(),
        ['Kedua', 'Pertama'],
      );

      expect(state.unreadCount, 2);
    });

    test('notifikasi baru memiliki status belum dibaca', () {
      final state = NotificationState(AppSettings());

      state.add('Judul', 'Isi');

      expect(state.items.first.read, isFalse);
    });

    test('tidak menambahkan notifikasi ketika dimatikan', () {
      final settings = AppSettings()
        ..setNotificationsEnabled(false);

      final state = NotificationState(settings);

      expect(
        state.add('Judul', 'Isi'),
        isFalse,
      );

      expect(state.isEmpty, isTrue);
    });

    test('markRead menandai notifikasi sudah dibaca', () {
      final state = NotificationState(AppSettings());

      state.add('Judul', 'Isi');

      final id = state.items.first.id;

      state.markRead(id);

      expect(state.items.first.read, isTrue);
      expect(state.unreadCount, 0);
    });

    test('markAllRead menandai semua notifikasi', () {
      final state = NotificationState(AppSettings());

      state.add('A', 'Isi A');
      state.add('B', 'Isi B');
      state.add('C', 'Isi C');

      state.markAllRead();

      expect(state.unreadCount, 0);
      expect(
        state.items.every((item) => item.read),
        isTrue,
      );
    });

    test('remove menghapus notifikasi berdasarkan ID', () {
      final state = NotificationState(AppSettings());

      state.add('A', 'Isi A');
      state.add('B', 'Isi B');

      final id = state.items.first.id;

      state.remove(id);

      expect(state.items.length, 1);
      expect(state.items.first.title, 'A');
    });

    test('clear menghapus semua notifikasi', () {
      final state = NotificationState(AppSettings());

      state.add('A', 'Isi A');
      state.add('B', 'Isi B');

      state.clear();

      expect(state.isEmpty, isTrue);
      expect(state.items, isEmpty);
    });

    test('ID notifikasi selalu berbeda', () {
      final state = NotificationState(AppSettings());

      state.add('A', 'Isi A');
      state.add('B', 'Isi B');

      expect(
        state.items[0].id,
        isNot(state.items[1].id),
      );
    });
  });
}
