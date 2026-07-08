import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:localguide/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parcours utilisateur complet', () {
    testWidgets('Rechercher un lieu, le consulter, l\'ajouter aux favoris et le retrouver', (tester) async {
      // Lancer l'application
      app.main();
      await tester.pumpAndSettle();

      // Vérifier que l'écran d'accueil est affiché
      expect(find.text('Découvrir'), findsOneWidget);

      // Saisir un terme de recherche (ex: "château")
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'château');
      await tester.pumpAndSettle();

      // Attendre que la liste se mette à jour (le filtrage est synchrone, mais on laisse le temps)
      await tester.pumpAndSettle();

      // Trouver la carte du premier résultat et cliquer dessus
      final firstCard = find.byType(Card).first;
      expect(firstCard, findsOneWidget);
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Vérifier qu'on est sur l'écran de détail
      expect(find.text('Détail'), findsOneWidget);

      // Vérifier que le nom du lieu s'affiche (ex: "Château de la Loire")
      expect(find.text('Château de la Loire'), findsOneWidget);

      // Ajouter aux favoris (icône cœur)
      final favButton = find.byIcon(Icons.favorite_border);
      expect(favButton, findsOneWidget);
      await tester.tap(favButton);
      await tester.pumpAndSettle();

      // Le cœur devient plein (favori ajouté)
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Revenir à l'accueil via la BottomNavigationBar
      final homeTab = find.text('Accueil');
      expect(homeTab, findsOneWidget);
      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      // Aller à l'onglet Favoris
      final favTab = find.text('Favoris');
      expect(favTab, findsOneWidget);
      await tester.tap(favTab);
      await tester.pumpAndSettle();

      // Vérifier que le lieu ajouté apparaît dans la liste des favoris
      expect(find.text('Château de la Loire'), findsOneWidget);

      // Optionnel : retirer des favoris
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Vérifier que le lieu a disparu des favoris
      expect(find.text('Château de la Loire'), findsNothing);
      expect(find.text('Aucun favori'), findsOneWidget);
    });
  });
}