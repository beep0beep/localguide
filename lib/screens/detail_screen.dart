import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/lieu_provider.dart';
import '../providers/favori_provider.dart';
import '../models/lieu.dart';

class DetailScreen extends ConsumerWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lieuAsync = ref.watch(lieuProvider(id));
    final isFavAsync = ref.watch(isFavoriProvider(id));
    final notifier = ref.watch(favoriNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail'),
        actions: [
          isFavAsync.when(
            data: (isFav) => lieuAsync.when(
              data: (lieu) => lieu != null
                  ? IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null),
                      onPressed: () => notifier.toggle(id),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: lieuAsync.when(
        data: (lieu) => lieu != null
            ? _Body(lieu: lieu)
            : const Center(child: Text('Lieu introuvable')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Lieu lieu;
  const _Body({required this.lieu});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lieu.imagesUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView(
                children: lieu.imagesUrls
                    .map((path) => Image.asset(
                          path,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey),
                        ))
                    .toList(),
              ),
            )
          else
            const Icon(Icons.image, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          Text(lieu.nom, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(lieu.adresse),
          const SizedBox(height: 8),
          if (lieu.horaires != null) Text('Horaires : ${lieu.horaires}'),
          const SizedBox(height: 8),
          Text(lieu.description),
          const SizedBox(height: 16),
          if (lieu.noteMoyenne != null)
            Row(children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(lieu.noteMoyenne!.toStringAsFixed(1)),
            ]),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/map'),
            icon: const Icon(Icons.map),
            label: const Text('Voir sur la carte'),
          ),
        ],
      ),
    );
  }
}
