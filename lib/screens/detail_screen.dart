import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
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
        data: (lieu) => lieu != null ? _Body(lieu: lieu) : const Center(child: Text('Lieu introuvable')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Lieu lieu;
  const _Body({required this.lieu});

  // Fonction d'ouverture de Google Maps (retourne un Future<bool> pour savoir si ça a marché)
  Future<bool> _openInGoogleMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${lieu.latitude},${lieu.longitude}',
    );
    try {
      // Tentative d'ouverture en mode externe (Google Maps si installé)
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Si pas de Google Maps, on essaie avec le mode par défaut (navigateur)
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
      return true;
    } catch (e) {
      // En cas d'erreur, on retourne false
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = lieu.imagesUrls.where((url) => url.isNotEmpty).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView(
                children: images.map((path) => Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                )).toList(),
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
            onPressed: () async {
              final success = await _openInGoogleMaps();
              if (!success) {
                // Affiche un message d'erreur si l'ouverture a échoué
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Impossible d\'ouvrir Google Maps. Vérifiez votre connexion.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: const Icon(Icons.map),
            label: const Text('Voir sur la carte'),
          ),
        ],
      ),
    );
  }
}