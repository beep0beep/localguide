import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lieu.dart';
import '../repositories/favori_repository.dart';

final favoriRepositoryProvider = Provider((ref) => FavoriRepository());

final favorisLieuxProvider = FutureProvider<List<Lieu>>((ref) async {
  final repo = ref.watch(favoriRepositoryProvider);
  return repo.getLieux();
});

final isFavoriProvider = FutureProvider.family<bool, String>((ref, lieuId) async {
  final repo = ref.watch(favoriRepositoryProvider);
  return repo.isFavori(lieuId);
});

class FavoriNotifier extends StateNotifier<Set<String>> {
  final Ref _ref;
  FavoriNotifier(this._ref) : super({});

  Future<void> loadFavoris() async {
    final repo = _ref.read(favoriRepositoryProvider);
    final ids = await repo.getIds();
    state = ids.toSet();
  }

  Future<void> toggle(String lieuId) async {
    final repo = _ref.read(favoriRepositoryProvider);
    final isFav = state.contains(lieuId);
    if (isFav) {
      await repo.remove(lieuId);
      state = {...state}..remove(lieuId);
    } else {
      await repo.add(lieuId);
      state = {...state, lieuId};
    }
    _ref.invalidate(favorisLieuxProvider);
    _ref.invalidate(isFavoriProvider(lieuId));
  }
}

final favoriNotifierProvider = StateNotifierProvider<FavoriNotifier, Set<String>>(
  (ref) => FavoriNotifier(ref),
);