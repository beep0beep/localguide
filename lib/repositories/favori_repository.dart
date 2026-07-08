import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_helper.dart';
import '../models/lieu.dart';

class FavoriRepository {
  final db = DatabaseHelper();

  Future<void> add(String lieuId) => db.addFavori(lieuId);
  Future<void> remove(String lieuId) => db.removeFavori(lieuId);
  Future<List<String>> getIds() => db.getFavorisIds();
  Future<bool> isFavori(String lieuId) => db.isFavori(lieuId);
  Future<List<Lieu>> getLieux() async {
    final data = await db.getFavorisLieux();
    return data.map((m) => Lieu.fromMap(m)).toList();
  }
}

final favoriRepositoryProvider = Provider((ref) => FavoriRepository());