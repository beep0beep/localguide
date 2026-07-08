import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lieu_provider.dart';
import '../models/lieu.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lieux = ref.watch(lieuxProvider).maybeWhen(
      data: (l) => l,
      orElse: () => <Lieu>[],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Carte (simulée)')),
      body: lieux.isEmpty
          ? const Center(child: Text('Aucun lieu à afficher'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: lieux.length,
              itemBuilder: (ctx, i) {
                final l = lieux[i];
                return Card(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/detail/${l.id}'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.place, color: Colors.red, size: 40),
                        Text(l.nom, textAlign: TextAlign.center),
                        Text(l.adresse, style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}