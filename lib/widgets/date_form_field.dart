import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/labeled_field.dart';

/// Membuka `showDatePicker` dengan rentang 1990 sampai 10 tahun ke depan.
/// Mengembalikan `null` jika dibatalkan. [initial] kosong berarti hari ini.
Future<DateTime?> pickDate(
  BuildContext context, {
  DateTime? initial,
  String? helpText,
}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initial ?? now,
    firstDate: DateTime(1990),
    lastDate: DateTime(now.year + 10),
    helpText: helpText,
  );
}

/// Field tanggal read-only dengan label di atasnya: menekannya memanggil
/// [onTap] (biasanya membuka date picker), dan [onClear] (jika ada)
/// menampilkan tombol hapus.
class DateFormField extends StatelessWidget {
  const DateFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.onTap,
    required this.validator,
    this.isRequired = false,
    this.onClear,
    this.clearTooltip = 'Hapus tanggal',
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;
  final String? Function(String?) validator;
  final bool isRequired;
  final VoidCallback? onClear;
  final String clearTooltip;

  @override
  Widget build(BuildContext context) {
    final clear = onClear;
    return LabeledField(
      label: label,
      isRequired: isRequired,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: oceanInputDecoration(
          hint: 'Pilih tanggal',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIcon: clear == null
              ? null
              : IconButton(
                  tooltip: clearTooltip,
                  icon: const Icon(Icons.clear),
                  onPressed: clear,
                ),
        ),
        validator: validator,
      ),
    );
  }
}
