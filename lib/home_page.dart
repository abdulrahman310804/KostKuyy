import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kostkuyy/profile_page.dart';
import 'package:kostkuyy/saved_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_page.dart' show AddPage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _kostList = [];
  final List<Map<String, dynamic>> _savedKostList = [];
  List<Map<String, dynamic>> _filteredKostList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSavedData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? kostString = prefs.getString('kostList');

    if (kostString != null) {
      final List<dynamic> kostData = jsonDecode(kostString);
      setState(() {
        _kostList.clear();
        for (var item in kostData) {
          _kostList.add(Map<String, dynamic>.from(item));
        }
        _filterKostList();
      });
    }
  }

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

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String kostString = jsonEncode(_kostList);
    prefs.setString('kostList', kostString);
  }

  Future<void> _saveSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedKostString = jsonEncode(_savedKostList);
    prefs.setString('savedKostList', savedKostString);
  }

  void _toggleFavorite(Map<String, dynamic> kost) {
    setState(() {
      if (_isFavorite(kost)) {
        _savedKostList
            .removeWhere((item) => item['namaKost'] == kost['namaKost']);
      } else {
        _savedKostList.add(kost);
      }
      _saveSavedData();
    });
  }

  bool _isFavorite(Map<String, dynamic> kost) {
    return _savedKostList.any((item) => item['namaKost'] == kost['namaKost']);
  }

  Future<void> _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _kostList.add(result);
      });
      if (kDebugMode) {
        print("Data yang diterima di HomePage: $result");
      }
      _saveData();
      _filterKostList();
    }
  }

  void _filterKostList() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredKostList = List.from(_kostList);
      } else {
        _filteredKostList = _kostList
            .where((kost) =>
                kost['namaKost']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                kost['alamat']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                kost['harga'].toString().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 247, 65),
        leading: IconButton(
          icon: const Icon(Icons.account_circle,
              color: Colors.white), // Icon Profile di kiri atas
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        title: const Center(
          child: Text('KostKuyy'), // Nama aplikasi di tengah
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kost...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              onChanged: (query) {
                _searchQuery = query;
                _filterKostList();
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/icon.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // Main content (list of kost)
          _filteredKostList.isEmpty
              ? const Center(child: Text('Belum ada data kost'))
              : ListView.builder(
                  itemCount: _filteredKostList.length,
                  itemBuilder: (context, index) {
                    final kost = _filteredKostList[index];
                    return Card(
                      color: Colors.green.shade50,
                      margin: const EdgeInsets.all(8),
                      elevation: 5,
                      shadowColor: const Color.fromARGB(255, 59, 247, 65),
                      child: ListTile(
                        leading: kost['image'] != null
                            ? Image.file(
                                File(kost['image']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image,
                                color: Color.fromARGB(255, 59, 247, 65)),
                        title: Text(kost['namaKost'] ?? ''),
                        subtitle: Text(
                            '${kost['harga']}\n${kost['alamat']}\n${kost['fasilitas']}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            _isFavorite(kost)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                _isFavorite(kost) ? Colors.red : Colors.green,
                          ),
                          onPressed: () => _toggleFavorite(kost),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 59, 247, 65),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_business_sharp, color: Colors.white),
              onPressed: _navigateToAddPage,
            ),
            IconButton(
              icon: const Icon(Icons.archive_sharp, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
