import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ImageProviderModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _images = [];
  late Database _db;

  List<Map<String, dynamic>> get images => _images;

  ImageProviderModel() {
    _initDb();
  }

  Future<void> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'images.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            type TEXT,
            date TEXT,
            path TEXT
          )
        ''');
      },
    );
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final data = await _db.query('images');
    _images.clear();
    _images.addAll(data);
    notifyListeners();
  }

  Future<void> addImage(Map<String, dynamic> image) async {
    await _db.insert('images', image);
    _fetchImages();
  }

  Future<void> updateImage(int id, Map<String, dynamic> image) async {
    await _db.update('images', image, where: 'id = ?', whereArgs: [id]);
    _fetchImages();
  }

  Future<void> deleteImage(int id) async {
    await _db.delete('images', where: 'id = ?', whereArgs: [id]);
    _fetchImages();
  }

  Future<void> searchImages(String query) async {
    final data = await _db.query(
      'images',
      where: 'name LIKE ? OR type LIKE ? OR date LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    _images.clear();
    _images.addAll(data);
    notifyListeners();
  }
}
