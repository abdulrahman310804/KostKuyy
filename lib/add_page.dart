// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _namaKostController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _saveData() {
    if (kDebugMode) {
      print(
          "Data yang disimpan: ${_namaKostController.text}, ${_hargaController.text}, ${_fasilitasController.text}, ${_alamatController.text}, ${_noHandphoneController.text}");
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap unggah foto sebelum menyimpan')),
      );
      return;
    }

    final Map<String, dynamic> data = {
      'namaKost': _namaKostController.text,
      'harga': _hargaController.text,
      'fasilitas': _fasilitasController.text,
      'alamat': _alamatController.text,
      'noHandphone': _noHandphoneController.text,
      'image': _selectedImage!.path, // Simpan path gambar
    };

    Navigator.pop(context, data); // Mengembalikan data ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posting Info Kost'),
        backgroundColor: const Color.fromARGB(
            255, 59, 247, 65), // Ubah warna AppBar menjadi hijau
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Kost Box
              _buildInputBox(
                controller: _namaKostController,
                labelText: 'Nama Kost',
                icon: Icons.home,
              ),
              const SizedBox(height: 16),

              // Harga Box
              _buildInputBox(
                controller: _hargaController,
                labelText: 'Harga',
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 16),

              // Fasilitas Box
              _buildInputBox(
                controller: _fasilitasController,
                labelText: 'Fasilitas',
                icon: Icons.chair,
              ),
              const SizedBox(height: 16),

              // Alamat Box
              _buildInputBox(
                controller: _alamatController,
                labelText: 'Alamat',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),

              // No Handphone Box
              _buildInputBox(
                controller: _noHandphoneController,
                labelText: 'No Handphone',
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),

              // Upload Foto Button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 59, 247, 65), // Warna hijau
                ),
                onPressed: _pickImage,
                child: const Text('Upload Foto'),
              ),

              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    _selectedImage!,
                    height: 150,
                  ),
                )
              else
                const Text(
                  'Belum ada foto yang dipilih',
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 20),

              // Simpan Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 59, 247, 65),
                ),
                onPressed: _saveData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat kotak input dengan ikon dan label
  Widget _buildInputBox({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon, color: Colors.green), // Ikon dengan warna hijau
        filled: true,
        fillColor:
            Colors.green.shade50, // Latar belakang kotak berwarna hijau muda
      ),
    );
  }
}
