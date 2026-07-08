import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lieu.dart';
import '../repositories/lieu_repository.dart';

final lieuxProvider = FutureProvider<List<Lieu>>((ref) async {
  final repo = ref.watch(lieuRepositoryProvider);
  return repo.getLieux();
});

final lieuProvider = FutureProvider.family<Lieu?, String>((ref, id) async {
  final repo = ref.watch(lieuRepositoryProvider);
  return repo.getLieu(id);
});