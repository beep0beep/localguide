import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lieu.dart';
import 'lieu_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String?>((ref) => null);

final filteredLieuxProvider = Provider<List<Lieu>>((ref) {
  final lieuxAsync = ref.watch(lieuxProvider);
  final lieux = lieuxAsync.maybeWhen(
    data: (list) => list,
    orElse: () => <Lieu>[],
  );
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final cat = ref.watch(categoryFilterProvider);
  return lieux.where((l) {
    final matchNom = l.nom.toLowerCase().contains(query);
    final matchCat = cat == null || l.categorie == cat;
    return matchNom && matchCat;
  }).toList();
});