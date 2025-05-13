import 'package:flutter/material.dart';
import 'package:sistema_sqlite/menu.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Menu());
  }
}
