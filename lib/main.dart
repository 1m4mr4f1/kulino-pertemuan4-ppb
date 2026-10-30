import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const WarungPosApp());
}

class WarungPosApp extends StatelessWidget {
  const WarungPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WarungPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}
