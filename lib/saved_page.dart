// saved_page.dart
import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tersimpan'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman tersimpan'),
      ),
    );
  }
}
