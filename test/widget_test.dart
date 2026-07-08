import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localguide/main.dart';
import 'package:localguide/screens/home_screen.dart';

void main() {
  testWidgets('L\'écran d\'accueil affiche le titre et le champ de recherche', (tester) async {
    // Construire l'écran dans un ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Vérifier que le titre de l'AppBar est présent
    expect(find.text('Découvrir'), findsOneWidget);

    // Vérifier que le champ de recherche est présent
    expect(find.byType(TextField), findsOneWidget);

    // Vérifier que le filtre "Tous" est présent
    expect(find.text('Tous'), findsOneWidget);
  });

  testWidgets('L\'application se lance sans erreur', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // Attendre que l'UI se stabilise
    await tester.pumpAndSettle();

    // Vérifier que l'AppBar principale est présente
    expect(find.text('Découvrir'), findsOneWidget);
  });
}