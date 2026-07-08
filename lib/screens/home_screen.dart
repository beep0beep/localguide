import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/lieu_provider.dart';
import '../providers/search_provider.dart';
import '../models/lieu.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lieuxState = ref.watch(lieuxProvider);
    final filteredLieux = ref.watch(filteredLieuxProvider);
    final categories = [
      'nature',
      'gastronomie',
      'culture',
      'activite',
      'autre'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Découvrir')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onChanged: (val) =>
                  ref.read(searchQueryProvider.notifier).state = val,
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                if (i == 0) {
                  final selected = ref.watch(categoryFilterProvider) == null;
                  return FilterChip(
                    label: const Text('Tous'),
                    selected: selected,
                    onSelected: (_) =>
                        ref.read(categoryFilterProvider.notifier).state = null,
                  );
                }
                final cat = categories[i - 1];
                final selected = ref.watch(categoryFilterProvider) == cat;
                return FilterChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) =>
                      ref.read(categoryFilterProvider.notifier).state = cat,
                );
              },
            ),
          ),
          Expanded(
            child: lieuxState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Erreur : $err')),
              data: (_) {
                if (filteredLieux.isEmpty) {
                  return const Center(child: Text('Aucun lieu trouvé'));
                }
                return ListView.builder(
                  itemCount: filteredLieux.length,
                  itemBuilder: (ctx, idx) {
                    final l = filteredLieux[idx];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => context.push('/detail/${l.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
