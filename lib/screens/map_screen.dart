import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/lieu_provider.dart';
import '../models/lieu.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  Future<void> _openInGoogleMaps(Lieu lieu) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${lieu.latitude},${lieu.longitude}',
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lieux = ref.watch(lieuxProvider).maybeWhen(
      data: (l) => l,
      orElse: () => <Lieu>[],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Carte')),
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
                    onTap: () => _openInGoogleMaps(l),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.place, color: Colors.red, size: 40),
                          const SizedBox(height: 4),
                          Text(
                            l.nom,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            l.adresse,
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}