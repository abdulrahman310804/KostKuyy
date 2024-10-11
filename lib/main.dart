import 'package:apk_kost/home_page.dart';
import 'package:apk_kost/profile_page.dart';
import 'package:apk_kost/saved_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'apk_kost',
      home: const HomePage(),
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/saved': (context) => const SavedPage(),
      },
    );
  }
}
