import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'localguide.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lieux (
        id TEXT PRIMARY KEY,
        nom TEXT NOT NULL,
        description TEXT,
        categorie TEXT,
        latitude REAL,
        longitude REAL,
        adresse TEXT,
        horaires TEXT,
        imagesUrls TEXT,
        noteMoyenne REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE favoris (
        lieuId TEXT PRIMARY KEY,
        dateAjout INTEGER
      )
    ''');
    await db.execute('CREATE INDEX idx_favoris_lieuId ON favoris(lieuId)');

    // URLs avec ID fixes – fonctionnent toujours
    final lieux = [
      {
        'id':'1','nom':'Château de la Loire','description':'Magnifique château renaissance.',
        'categorie':'culture','latitude':47.259,'longitude':-0.077,
        'adresse':'15 Rue du Château, 37000 Tours','horaires':'10:00-18:00',
        'imagesUrls':'https://picsum.photos/id/1015/400/300,https://picsum.photos/id/1016/400/300',
        'noteMoyenne':4.7
      },
      {
        'id':'2','nom':'Restaurant Le Terroir','description':'Cuisine régionale authentique.',
        'categorie':'gastronomie','latitude':47.392,'longitude':0.688,
        'adresse':'5 Place du Marché, 37000 Tours','horaires':'12:00-14:30,19:00-22:00',
        'imagesUrls':'https://picsum.photos/id/1060/400/300,https://picsum.photos/id/1061/400/300',
        'noteMoyenne':4.5
      },
      {
        'id':'3','nom':'Parc Naturel Régional','description':'Espace protégé avec sentiers.',
        'categorie':'nature','latitude':47.500,'longitude':0.900,
        'adresse':'Route de la Forêt, 37000 Tours','horaires':'8:00-20:00',
        'imagesUrls':'https://picsum.photos/id/1040/400/300,https://picsum.photos/id/1041/400/300',
        'noteMoyenne':4.8
      },
      {
        'id':'4','nom':'Canoë-Kayak','description':'Descente de rivière encadrée.',
        'categorie':'activite','latitude':47.220,'longitude':0.150,
        'adresse':'Base nautique, 37000 Tours','horaires':'9:00-17:00',
        'imagesUrls':'https://picsum.photos/id/1025/400/300,https://picsum.photos/id/1026/400/300',
        'noteMoyenne':4.3
      },
      {
        'id':'5','nom':'Cathédrale Saint-Gatien','description':'Cathédrale gothique du XIIIe.',
        'categorie':'culture','latitude':47.396,'longitude':0.694,
        'adresse':'Place de la Cathédrale, 37000 Tours','horaires':'9:30-18:00',
        'imagesUrls':'https://picsum.photos/id/1039/400/300,https://picsum.photos/id/1044/400/300',
        'noteMoyenne':4.6
      },
    ];
    for (var l in lieux) {
      await db.insert('lieux', l, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getLieux() async {
    final db = await database;
    return await db.query('lieux');
  }

  Future<Map<String, dynamic>?> getLieu(String id) async {
    final db = await database;
    final res = await db.query('lieux', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> addFavori(String lieuId) async {
    final db = await database;
    await db.insert('favoris', {'lieuId': lieuId, 'dateAjout': DateTime.now().millisecondsSinceEpoch},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavori(String lieuId) async {
    final db = await database;
    await db.delete('favoris', where: 'lieuId = ?', whereArgs: [lieuId]);
  }

  Future<bool> isFavori(String lieuId) async {
    final db = await database;
    final res = await db.query('favoris', where: 'lieuId = ?', whereArgs: [lieuId]);
    return res.isNotEmpty;
  }

  Future<List<String>> getFavorisIds() async {
    final db = await database;
    final res = await db.query('favoris');
    return res.map((row) => row['lieuId'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getFavorisLieux() async {
    final ids = await getFavorisIds();
    if (ids.isEmpty) return [];
    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    return await db.query('lieux', where: 'id IN ($placeholders)', whereArgs: ids);
  }
}