import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_helper.dart';
import '../models/lieu.dart';

class LieuRepository {
  final db = DatabaseHelper();

  Future<List<Lieu>> getLieux() async {
    final data = await db.getLieux();
    return data.map((m) => Lieu.fromMap(m)).toList();
  }

  Future<Lieu?> getLieu(String id) async {
    final data = await db.getLieu(id);
    return data != null ? Lieu.fromMap(data) : null;
  }
}

final lieuRepositoryProvider = Provider((ref) => LieuRepository());