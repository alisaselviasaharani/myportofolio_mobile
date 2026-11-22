import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Tombol aksi berbentuk kartu pastel untuk satu [ItemHomepage].
///
/// Warna latar dibaca dari `item.color`, warna ikon dari `item.iconColor`,
/// dan teks memakai biru tua. Menekan kartu menampilkan SnackBar
/// "Kamu telah menekan tombol [Nama Tombol]!", lalu membuka halaman tujuan
/// (`item.pageBuilder`) dengan `Navigator.push()` jika item punya tujuan.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: OceanColors.deep.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        // Warna latar diambil dari model, jadi tiap tombol punya warna sendiri.
        color: item.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
        ),
        child: InkWell(
          // Aksi ketika kartu ditekan oleh pengguna.
          onTap: () {
            // Menampilkan SnackBar dengan pesan interaktif.
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Kamu telah menekan tombol ${item.name}!"),
                ),
              );
            // Navigate ke halaman tujuan milik item (jika ada).
            final pageBuilder = item.pageBuilder;
            if (pageBuilder != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: pageBuilder),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: item.iconColor, size: 40.0),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: OceanColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.0,
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
