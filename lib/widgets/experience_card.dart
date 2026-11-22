import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

/// Tombol aksi berbentuk kartu pastel untuk satu [ItemHomepage].
///
/// Warna latar dibaca dari `item.color`, sedangkan warna ikon dan teks dibuat
/// dengan menggelapkan warna itu. Menekan kartu menampilkan SnackBar
/// "Kamu telah menekan tombol [Nama Tombol]!", lalu membuka halaman tujuan
/// (`item.pageBuilder`) dengan `Navigator.push()` jika item punya tujuan.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final foreground = Color.lerp(item.color, Colors.black, 0.6)!;
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: Colors.black26,
      // Warna latar diambil dari model, jadi tiap tombol punya warna sendiri.
      color: item.color,
      borderRadius: BorderRadius.circular(22),
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
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lingkaran putih translusen di belakang ikon.
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
                child: Icon(item.icon, color: foreground, size: 28.0),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
