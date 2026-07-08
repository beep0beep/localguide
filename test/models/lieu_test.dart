import 'package:flutter_test/flutter_test.dart';
import 'package:localguide/models/lieu.dart';

void main() {
  group('Lieu Model', () {
    test('fromMap crée un objet Lieu correctement', () {
      final map = {
        'id': '1',
        'nom': 'Château',
        'description': 'Un beau château',
        'categorie': 'culture',
        'latitude': 47.259,
        'longitude': -0.077,
        'adresse': '15 Rue du Château',
        'horaires': '10:00-18:00',
        'imagesUrls': 'assets/images/chateau.jpg',
        'noteMoyenne': 4.7,
      };

      final lieu = Lieu.fromMap(map);

      expect(lieu.id, '1');
      expect(lieu.nom, 'Château');
      expect(lieu.categorie, 'culture');
      expect(lieu.latitude, 47.259);
      expect(lieu.longitude, -0.077);
      expect(lieu.adresse, '15 Rue du Château');
      expect(lieu.horaires, '10:00-18:00');
      expect(lieu.imagesUrls, ['assets/images/chateau.jpg']);
      expect(lieu.noteMoyenne, 4.7);
    });

    test('fromMap gère les champs manquants', () {
      final map = {
        'id': '2',
        'nom': 'Restaurant',
        // description manquante, catégorie manquante, etc.
      };

      final lieu = Lieu.fromMap(map);

      expect(lieu.id, '2');
      expect(lieu.nom, 'Restaurant');
      expect(lieu.description, '');
      expect(lieu.categorie, '');
      expect(lieu.latitude, 0.0);
      expect(lieu.longitude, 0.0);
      expect(lieu.adresse, '');
      expect(lieu.horaires, null);
      expect(lieu.imagesUrls, []);
      expect(lieu.noteMoyenne, null);
    });
  });
}