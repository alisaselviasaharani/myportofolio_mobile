import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';

/// Titik masuk aplikasi.
void main() {
  runApp(const MyApp());
}

/// Widget root: membangun [MaterialApp] (tema + halaman awal [MyHomePage]).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
