// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final List<Map<String, dynamic>> _savedKostList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Fungsi untuk mengambil data kost favorit
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedKostString = prefs.getString('savedKostList');

    if (savedKostString != null) {
      final List<dynamic> savedKostData = jsonDecode(savedKostString);
      setState(() {
        _savedKostList.clear();
        for (var item in savedKostData) {
          _savedKostList.add(Map<String, dynamic>.from(item));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kost Tersimpan'),
        backgroundColor: const Color.fromARGB(
            255, 59, 247, 65), // Mengubah warna AppBar menjadi hijau
      ),
      body: _savedKostList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada kost yang disimpan',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _savedKostList.length,
              itemBuilder: (context, index) {
                final kost = _savedKostList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    side: const BorderSide(
                        color: Colors.green, width: 2), // Border hijau
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menampilkan gambar kost jika ada
                        kost['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(kost['image']),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.image, size: 50),
                              ),
                        const SizedBox(width: 10),
                        // Detail kost
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kost['namaKost'] ?? 'Nama tidak tersedia',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Harga: ${kost['harga'] ?? '-'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Alamat: ${kost['alamat'] ?? '-'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Fasilitas: ${kost['fasilitas'] ?? '-'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
