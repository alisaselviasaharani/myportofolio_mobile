import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/illustrations.dart';
import 'package:myportofolio_mobile/widgets/mascots.dart';

/// Satu baris ringkasan pada dialog. [value] kosong ditampilkan sebagai "-".
class SummaryItem {
  const SummaryItem({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;
}

/// Menampilkan dialog ringkasan isian formulir: ubur-ubur di kiri atas,
/// tanda centang hijau, judul, kotak ringkasan, bintang laut, dan tombol OK.
///
/// Tombol OK menutup dialog lalu memanggil [onClosed], misalnya untuk
/// mereset form. Parameter [closeLabel], [closeIcon], dan [emoji] dipertahankan
/// agar pemanggil lama tetap kompatibel, tetapi tidak lagi mengubah tampilan.
void showSummaryDialog(
  BuildContext context, {
  required String title,
  required List<SummaryItem> items,
  String? message,
  String closeLabel = 'OK',
  IconData closeIcon = Icons.check,
  String emoji = '',
  VoidCallback? onClosed,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 34),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8FD),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7ED957), Color(0xFF2EB82E)],
                        ),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: OceanColors.navy,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: OceanColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message ?? 'Here is the summary of your input:',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: OceanColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFCFEAF5)),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < items.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1,
                                color: Color(0xFFCFEAF5),
                              ),
                            _SummaryRow(item: items[i]),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _OkButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          onClosed?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ubur-ubur menonjol di kiri atas dialog.
            const Positioned(
              left: 6,
              top: -6,
              child: JellyfishMascot(width: 62),
            ),
            // Bintang laut di kanan bawah kotak ringkasan.
            const Positioned(
              right: 8,
              bottom: 56,
              child: StarfishMascot(size: 46),
            ),
          ],
        ),
      );
    },
  );
}

class _OkButton extends StatelessWidget {
  const _OkButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OceanColors.buttonStart, OceanColors.buttonEnd],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const Center(
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.item});

  final SummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, color: OceanColors.navy, size: 28),
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
                    color: OceanColors.navy,
                  ),
                ),
                Text(
                  item.value.isEmpty ? '-' : item.value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OceanColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
