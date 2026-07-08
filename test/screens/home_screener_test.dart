import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localguide/models/lieu.dart';
import 'package:localguide/providers/lieu_provider.dart';
import 'package:localguide/screens/home_screen.dart';

void main() {
  // Fournisseur de données mockées
  final mockLieux = [
    Lieu(
      id: '1',
      nom: 'Château',
      description: 'Beau château',
      categorie: 'culture',
      latitude: 47.259,
      longitude: -0.077,
      adresse: '15 Rue du Château',
      horaires: '10:00-18:00',
      imagesUrls: ['assets/images/chateau.jpg'],
      noteMoyenne: 4.7,
    ),
    Lieu(
      id: '2',
      nom: 'Restaurant',
      description: 'Bon restaurant',
      categorie: 'gastronomie',
      latitude: 47.392,
      longitude: 0.688,
      adresse: '5 Place du Marché',
      horaires: '12:00-14:30',
      imagesUrls: ['assets/images/restaurant.jpg'],
      noteMoyenne: 4.5,
    ),
  ];

  // Provider override pour lieuxProvider
  final mockLieuxProvider = FutureProvider<List<Lieu>>((ref) async => mockLieux);

  testWidgets('HomeScreen affiche la liste des lieux', (tester) async {
    // Créer un container avec le provider mocké
    final container = ProviderContainer(
      overrides: [
        lieuxProvider.overrideWithProvider(mockLieuxProvider),
        // On peut aussi override filteredLieuxProvider pour ne pas dépendre du filtre
        // Mais on va juste laisser le filtre fonctionner normalement (sans requête)
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Attendre le chargement
    await tester.pumpAndSettle();

    // Vérifier que les noms des lieux sont affichés
    expect(find.text('Château'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
    // Vérifier que la barre de recherche est présente
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Filtrage par recherche fonctionne', (tester) async {
    final container = ProviderContainer(
      overrides: [
        lieuxProvider.overrideWithProvider(mockLieuxProvider),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Entrer du texte dans la barre de recherche
    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'Château');
    await tester.pumpAndSettle();

    // Seul "Château" doit être visible
    expect(find.text('Château'), findsOneWidget);
    expect(find.text('Restaurant'), findsNothing);
  });
}