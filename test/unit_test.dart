import 'package:flutter_test/flutter_test.dart';
import 'package:localguide/models/lieu.dart';

void main() {
  group('Filtrage des lieux', () {
    final lieux = [
      Lieu(
        id: '1',
        nom: 'Château de la Loire',
        description: 'Magnifique château',
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
        nom: 'Restaurant Le Terroir',
        description: 'Cuisine régionale',
        categorie: 'gastronomie',
        latitude: 47.392,
        longitude: 0.688,
        adresse: '5 Place du Marché',
        horaires: '12:00-14:30',
        imagesUrls: ['assets/images/restaurant.jpg'],
        noteMoyenne: 4.5,
      ),
    ];

    test('Filtre par nom (recherche "château")', () {
      final query = 'château'.toLowerCase();
      final result = lieux.where((l) => l.nom.toLowerCase().contains(query)).toList();
      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('Filtre par catégorie (gastronomie)', () {
      final category = 'gastronomie';
      final result = lieux.where((l) => l.categorie == category).toList();
      expect(result.length, 1);
      expect(result.first.id, '2');
    });

    test('Filtre combiné (nom + catégorie) – aucun résultat', () {
      final query = 'parc'.toLowerCase();
      final category = 'culture';
      final result = lieux.where((l) {
        return l.nom.toLowerCase().contains(query) && l.categorie == category;
      }).toList();
      expect(result.isEmpty, true);
    });
  });
}