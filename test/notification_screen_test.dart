import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/notification_screen.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/notification_state.dart';
import 'package:myportofolio_mobile/utils/notify.dart';
import 'package:provider/provider.dart';

Widget _app(AppSettings settings, NotificationState state, {Widget? home}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: settings),
      ChangeNotifierProvider.value(value: state),
    ],
    child: MaterialApp(home: home ?? const NotificationScreen()),
  );
}

void main() {
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('kosong menampilkan pesan belum ada notifikasi', (tester) async {
    tall(tester);
    final settings = AppSettings();
    await tester.pumpWidget(_app(settings, NotificationState(settings)));

    expect(find.textContaining('Belum ada notifikasi'), findsOneWidget);
  });

  testWidgets('menampilkan notifikasi dan menandainya dibaca', (tester) async {
    tall(tester);
    final settings = AppSettings();
    final state = NotificationState(settings)..add('Pendidikan ditambahkan', 'UI');
    await tester.pumpWidget(_app(settings, state));

    expect(find.text('Pendidikan ditambahkan'), findsOneWidget);
    expect(state.unreadCount, 1);

    await tester.tap(find.text('Pendidikan ditambahkan'));
    await tester.pump();
    expect(state.unreadCount, 0);
  });

  testWidgets('tombol hapus semua mengosongkan daftar', (tester) async {
    tall(tester);
    final settings = AppSettings();
    final state = NotificationState(settings)
      ..add('A', 'a')
      ..add('B', 'b');
    await tester.pumpWidget(_app(settings, state));

    await tester.tap(find.byKey(const Key('clearNotificationsButton')));
    await tester.pump();
    expect(state.isEmpty, isTrue);
  });

  testWidgets('saklar mematikan notifikasi baru', (tester) async {
    tall(tester);
    final settings = AppSettings();
    final state = NotificationState(settings);
    await tester.pumpWidget(_app(settings, state));

    await tester.tap(find.byKey(const Key('notificationsSwitch')));
    await tester.pump();
    expect(settings.notificationsEnabled, isFalse);
    expect(state.add('X', 'x'), isFalse);
  });

  testWidgets('pushNotification aman tanpa NotificationState', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(() => pushNotification(ctx, 't', 'b'), returnsNormally);
  });
}
