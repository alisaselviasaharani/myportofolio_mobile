import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/ocean_button.dart';

/// Satu baris ringkasan pada dialog. [value] kosong ditampilkan sebagai "-".
class SummaryItem {
  const SummaryItem({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;
}

/// Menampilkan [AlertDialog] ringkasan isian formulir.
///
/// Isian ditata dalam satu kotak putih berpembatas. Tombol penutup (label
/// [closeLabel]) menutup dialog lalu memanggil [onClosed], misalnya untuk
/// mereset form.
void showSummaryDialog(
  BuildContext context, {
  required String title,
  required List<SummaryItem> items,
  String? message,
  String closeLabel = 'OK',
  IconData closeIcon = Icons.check,
  String emoji = '🐳',
  VoidCallback? onClosed,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF1FBFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: Text(emoji, style: const TextStyle(fontSize: 64)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(message),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: OceanColors.aqua),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      _SummaryRow(item: items[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          OceanButton(
            label: closeLabel,
            icon: closeIcon,
            onPressed: () {
              Navigator.pop(dialogContext);
              onClosed?.call();
            },
          ),
        ],
      );
    },
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.item});

  final SummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, color: OceanColors.deep, size: 22),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: OceanColors.deep,
                  ),
                ),
                Text(item.value.isEmpty ? '-' : item.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
