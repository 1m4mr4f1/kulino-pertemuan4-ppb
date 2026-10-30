import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pos_provider.dart';
import 'theme/app_theme.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PosProvider()..loadProducts(),
      child: const WarungPosApp(),
    ),
  );
}

class WarungPosApp extends StatelessWidget {
  const WarungPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WarungPOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogScreen(),
    );
  }
}
