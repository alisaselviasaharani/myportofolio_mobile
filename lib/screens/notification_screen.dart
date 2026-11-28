import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/l10n/app_strings.dart';
import 'package:myportofolio_mobile/models/notification.dart';
import 'package:myportofolio_mobile/services/app_settings.dart';
import 'package:myportofolio_mobile/services/notification_state.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';
import 'package:myportofolio_mobile/widgets/ocean_bottom_bar.dart';
import 'package:provider/provider.dart';

/// Halaman Notifikasi: saklar aktif/nonaktif, daftar notifikasi, tandai
/// dibaca, geser untuk menghapus, dan hapus semua.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  /// Waktu relatif singkat, mis. "Baru saja", "5 mnt lalu".
  static String _ago(DateTime time, AppStrings strings) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return strings.get('justNow');
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${strings.get('minutesAgo')}';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} ${strings.get('hoursAgo')}';
    }
    return '${diff.inDays} ${strings.get('daysAgo')}';
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final settings = context.watch<AppSettings>();
    final state = context.watch<NotificationState>();
    final items = state.items;
    final top = MediaQuery.paddingOf(context).top + oceanAppBarHeight;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: oceanAppBar(
        title: strings.notifications,
        actions: [
          if (state.unreadCount > 0)
            IconButton(
              key: const Key('markAllReadButton'),
              tooltip: strings.get('markAllRead'),
              icon: const Icon(Icons.done_all, color: Colors.white),
              onPressed: state.markAllRead,
            ),
          if (!state.isEmpty)
            IconButton(
              key: const Key('clearNotificationsButton'),
              tooltip: strings.get('clearAll'),
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.white),
              onPressed: state.clear,
            ),
        ],
      ),
      bottomNavigationBar: const OceanBottomBar(),
      body: OceanBackground(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 120),
          children: [
            // Material (bukan Container berwarna) agar latar dan efek ink
            // ListTile tidak tertutup dekorasi.
            Material(
              color: Colors.white.withValues(alpha: 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(color: Colors.white, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                key: const Key('notificationsSwitch'),
                value: settings.notificationsEnabled,
                onChanged: settings.setNotificationsEnabled,
                secondary: const Icon(
                  Icons.notifications_active_outlined,
                  color: OceanColors.navy,
                ),
                title: Text(
                  strings.get('notificationsOn'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: OceanColors.navy.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.get('noNotifications'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: OceanColors.navy,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _NotificationTile(
                    item: item,
                    time: _ago(item.createdAt, strings),
                    onTap: () => state.markRead(item.id),
                    onDismissed: () => state.remove(item.id),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.time,
    required this.onTap,
    required this.onDismissed,
  });

  final AppNotification item;
  final String time;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('notification_${item.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Material(
        color: Colors.white.withValues(alpha: item.read ? 0.55 : 0.92),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item.read
                      ? Icons.notifications_none
                      : Icons.notifications_active,
                  color: OceanColors.navy,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontWeight:
                              item.read ? FontWeight.w600 : FontWeight.w800,
                          fontSize: 15,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: OceanColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: OceanColors.navy.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.read)
                  Container(
                    margin: const EdgeInsets.only(top: 6, left: 8),
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
