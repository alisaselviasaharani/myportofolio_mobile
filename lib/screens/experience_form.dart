import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/ocean_theme.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/ocean_background.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _position = "";
  String _company = "";
  String _description = "";
  String _type = "Full-time"; // default
  String _period = "";
  String _link = "";

  final List<String> _types = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance',
    'Volunteer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: oceanAppBar(title: 'Add Experience Form'),
      // Drawer yang sama dengan halaman utama
      drawer: const LeftDrawer(selected: DrawerDestination.experience),
      body: OceanBackground(
        child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Position ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: oceanInputDecoration(label: "Posisi / Jabatan", hint: "Posisi / Jabatan"),
                  onChanged: (String? value) {
                    setState(() {
                      _position = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Posisi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // === Company ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: oceanInputDecoration(label: "Perusahaan / Organisasi", hint: "Nama Perusahaan / Organisasi"),
                  onChanged: (String? value) {
                    setState(() {
                      _company = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Perusahaan / organisasi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: oceanInputDecoration(label: "Deskripsi Experience", hint: "Deskripsi Experience"),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // === Type ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: oceanInputDecoration(label: "Tipe Experience"),
                  initialValue: _type,
                  items: _types
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _type = newValue!;
                    });
                  },
                ),
              ),
              // === Period ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: oceanInputDecoration(label: "Periode", hint: "Contoh: Jan 2025 - Des 2025"),
                  onChanged: (String? value) {
                    setState(() {
                      _period = value!;
                    });
                  },
                ),
              ),
              // === Link ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: oceanInputDecoration(label: "Tautan Experience", hint: "URL Experience (opsional)"),
                  onChanged: (String? value) {
                    setState(() {
                      _link = value!;
                    });
                  },
                ),
              ),
              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(OceanColors.deep),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:
                                  const Text('Experience berhasil ditambahkan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Posisi: $_position'),
                                    Text('Perusahaan: $_company'),
                                    Text('Deskripsi: $_description'),
                                    Text('Tipe: $_type'),
                                    Text('Periode: $_period'),
                                    Text('Tautan: $_link'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    // Samakan variabel dengan tampilan form
                                    // yang sudah di-reset.
                                    setState(() {
                                      _position = "";
                                      _company = "";
                                      _description = "";
                                      _type = _types.first;
                                      _period = "";
                                      _link = "";
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
