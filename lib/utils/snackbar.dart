import 'package:material_ui/material_ui.dart';

/// Menampilkan SnackBar singkat, menggantikan SnackBar yang sedang tampil.
void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
