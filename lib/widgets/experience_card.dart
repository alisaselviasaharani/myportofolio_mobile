import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

/// Tombol aksi berbentuk kartu berwarna untuk satu [ItemHomepage].
///
/// Warna latar dibaca dari `item.color`. Menekan kartu menampilkan SnackBar
/// "Kamu telah menekan tombol [Nama Tombol]!", lalu membuka halaman tujuan
/// (`item.pageBuilder`) dengan `Navigator.push()` jika item punya tujuan.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: item.color.withValues(alpha: 0.5),
      // Warna latar diambil dari model, jadi tiap tombol punya warna sendiri.
      color: item.color,
      borderRadius: BorderRadius.circular(16),
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
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 34.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
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