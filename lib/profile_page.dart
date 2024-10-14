// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Impor image_picker

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _password = '';
  String _alamat = '';
  String _tanggalLahir = '';
  String _jenisKelamin = '';
  String _fotoPath = ''; // Menyimpan path foto
  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Tidak ada username';
      _password = prefs.getString('password') ?? 'Tidak ada password';
      _alamat = prefs.getString('alamat') ?? 'Belum diisi';
      _tanggalLahir = prefs.getString('tanggalLahir') ?? 'Belum diisi';
      _jenisKelamin = prefs.getString('jenisKelamin') ?? 'Belum diisi';
      _fotoPath = prefs.getString('foto') ?? ''; // Mengambil path foto
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('alamat', _alamat);
    await prefs.setString('tanggalLahir', _tanggalLahir);
    await prefs.setString('jenisKelamin', _jenisKelamin);
    await prefs.setString('foto', _fotoPath);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoPath = image.path; // Menyimpan path gambar
      });
      _saveUserData(); // Simpan path foto ke SharedPreferences
    }
  }

  void _editField(String fieldType) {
    String currentValue = '';
    switch (fieldType) {
      case 'alamat':
        currentValue = _alamat;
        break;
      case 'tanggalLahir':
        currentValue = _tanggalLahir;
        break;
      case 'jenisKelamin':
        currentValue = _jenisKelamin;
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller =
            TextEditingController(text: currentValue);
        return AlertDialog(
          title: Text('Edit $fieldType'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: fieldType),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (fieldType == 'alamat') {
                    _alamat = controller.text;
                  } else if (fieldType == 'tanggalLahir') {
                    _tanggalLahir = controller.text;
                  } else if (fieldType == 'jenisKelamin') {
                    _jenisKelamin = controller.text;
                  }
                });
                _saveUserData(); // Simpan data setelah diedit
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor:
            const Color.fromARGB(255, 59, 247, 65), // Mengubah warna app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Box untuk menampilkan foto
            GestureDetector(
              onTap: _pickImage, // Panggil fungsi untuk memilih gambar
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 59, 247, 65), width: 2),
                  borderRadius: BorderRadius.circular(8),
                  image: _fotoPath.isNotEmpty
                      ? DecorationImage(
                          image:
                              FileImage(File(_fotoPath)), // Gunakan FileImage
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _fotoPath.isEmpty
                    ? const Center(child: Text('Tambah Foto'))
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Tambahan untuk menampilkan Username dan Password
            _buildProfileBox('Username', _username, ''),
            const SizedBox(height: 10),
            _buildProfileBox('Password', _password, ''),
            const SizedBox(height: 20),

            // Kotak untuk Alamat
            _buildProfileBox('Alamat', _alamat, 'alamat'),
            const SizedBox(height: 10),

            // Kotak untuk Tanggal Lahir
            _buildProfileBox('Tanggal Lahir', _tanggalLahir, 'tanggalLahir'),
            const SizedBox(height: 10),

            // Kotak untuk Jenis Kelamin
            _buildProfileBox('Jenis Kelamin', _jenisKelamin, 'jenisKelamin'),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Menghapus data login
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBox(String title, String value, String fieldType) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color.fromARGB(255, 59, 247, 65), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child:
                  Text('$title: $value', style: const TextStyle(fontSize: 18))),
          if (fieldType.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editField(fieldType), // Edit field
            ),
        ],
      ),
    );
  }
}
