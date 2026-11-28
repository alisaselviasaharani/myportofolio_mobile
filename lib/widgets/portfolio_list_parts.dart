import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';

/// Ikon bulat di kanan AppBar (sama seperti halaman Pendidikan).
class PortfolioHeaderBadge extends StatelessWidget {
  const PortfolioHeaderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        ),
        child: const Icon(Icons.face_outlined, color: Colors.white, size: 24),
      ),
    );
  }
}

/// Tombol filter bulat putih yang membuka menu pilihan [T].
class PortfolioFilterButton<T> extends StatelessWidget {
  const PortfolioFilterButton({
    super.key,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onSelected,
    this.tooltip = 'Filter',
  });

  final T value;
  final List<T> options;
  final String Function(T option) labelOf;
  final ValueChanged<T> onSelected;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      key: const Key('filterButton'),
      tooltip: tooltip,
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem<T>(value: option, child: Text(labelOf(option))),
      ],
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCFEAF5)),
        ),
        child: const Icon(Icons.filter_list, color: OceanColors.navy, size: 28),
      ),
    );
  }
}

/// Tombol "+ Tambah" berbentuk kapsul ungu.
class PortfolioAddPill extends StatelessWidget {
  const PortfolioAddPill({
    super.key,
    required this.onPressed,
    this.buttonKey = const Key('addButton'),
  });

  final VoidCallback onPressed;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: buttonKey,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OceanColors.purpleStart, OceanColors.purpleEnd],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2),
        boxShadow: [
          BoxShadow(
            color: OceanColors.purpleEnd.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 26),
                SizedBox(width: 8),
                Text(
                  'Tambah',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
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

/// Kartu pesan di tengah layar untuk daftar kosong atau hasil tidak ditemukan.
class PortfolioEmptyState extends StatelessWidget {
  const PortfolioEmptyState({
    super.key,
    required this.icon,
    required this.message,
    required this.hint,
  });

  final IconData icon;
  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: OceanColors.deep, size: 40),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: OceanColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OceanColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu pesan gagal memuat dari server, dengan tombol coba lagi.
class PortfolioErrorState extends StatelessWidget {
  const PortfolioErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: OceanColors.deep, size: 40),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: OceanColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pastikan backend Django berjalan, lalu coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: OceanColors.navy),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              key: const Key('retryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bagian atas detail: panel gradasi (pengganti foto kampus) dengan tombol
/// bulat di kanan atas dan [badge] yang menumpuk di kiri bawah.
class PortfolioDetailHero extends StatelessWidget {
  const PortfolioDetailHero({
    super.key,
    required this.icon,
    required this.badge,
    required this.actions,
    this.colors = const [OceanColors.aqua, OceanColors.teal],
    this.backdrop,
  });

  final IconData icon;
  final Widget badge;
  final List<Widget> actions;
  final List<Color> colors;

  /// Gambar latar opsional (misalnya gambar achievement dari Django).
  final Widget? backdrop;

  static const double _photoHeight = 160;
  static const double _overlap = 34;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 64,
          color: Colors.white.withValues(alpha: 0.85),
        ),
      ),
    );
    return SizedBox(
      height: 8 + _photoHeight + _overlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            height: _photoHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: backdrop ?? placeholder,
            ),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: Row(
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  actions[i],
                ],
              ],
            ),
          ),
          Positioned(left: 12, bottom: 0, child: badge),
        ],
      ),
    );
  }
}

/// Tombol bulat putih kecil (bagikan, dll.) di atas hero.
class PortfolioRoundAction extends StatelessWidget {
  const PortfolioRoundAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.95),
        elevation: 2,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: OceanColors.navy, size: 22),
          ),
        ),
      ),
    );
  }
}

/// Tabel info (ikon, label, nilai) dalam panel putih transparan.
class PortfolioInfoTable extends StatelessWidget {
  const PortfolioInfoTable({super.key, required this.rows});

  final List<PortfolioInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFD5EAF4)),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class PortfolioInfoRow extends StatelessWidget {
  const PortfolioInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = OceanColors.navy,
    this.valueKey,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: OceanColors.navy, size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: OceanColors.navy,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              key: valueKey,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Judul bagian pada halaman detail, misalnya "Deskripsi".
class PortfolioSectionTitle extends StatelessWidget {
  const PortfolioSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: OceanColors.navy,
      ),
    );
  }
}
