import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // <-- Import ajouté
import '../providers/favori_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lieuxAsync = ref.watch(favorisLieuxProvider);
    final notifier = ref.watch(favoriNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: lieuxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Erreur : $err')),
        data: (lieux) {
          if (lieux.isEmpty) return const Center(child: Text('Aucun favori'));
          return ListView.builder(
            itemCount: lieux.length,
            itemBuilder: (_, i) {
              final l = lieux[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: l.imagesUrls.isNotEmpty
                      ? Image.asset(
                          l.imagesUrls.first,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 40),
                        )
                      : const Icon(Icons.place, size: 40),
                  title: Text(l.nom),
                  subtitle: Text(l.adresse),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => notifier.toggle(l.id),
                  ),
                  onTap: () => context.push('/detail/${l.id}'), // <-- Utilisation de go_router
                ),
              );
            },
          );
        },
      ),
    );
  }
}