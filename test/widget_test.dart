// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immofinder/main.dart';
import 'package:immofinder/screens/home_screen.dart';

void main() {
  testWidgets('shows splash screen then opens login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ImmoFinderApp());

    expect(find.text('Trouvez votre bien idéal\nen Tunisie'), findsOneWidget);
    expect(find.text('Connectez-vous pour continuer'), findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
  });

  testWidgets('category icons filter the home announcements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    for (final category in ['Vente', 'Location', 'Neuf', 'Terrain']) {
      await tester.tap(find.text(category));
      await tester.pumpAndSettle();

      expect(find.text('Annonces $category'), findsOneWidget);
      if (category == 'Vente') {
        expect(find.text('Appartement S+2'), findsOneWidget);
        expect(find.text('Villa avec piscine'), findsOneWidget);
      } else if (category == 'Location') {
        expect(find.text('Villa familiale avec jardin'), findsOneWidget);
      } else if (category == 'Neuf') {
        expect(find.text('Résidence neuve S+3'), findsOneWidget);
      } else {
        expect(
          find.text('Aucune annonce disponible pour cette catégorie.'),
          findsOneWidget,
        );
      }

      await tester.tap(find.text('Tout voir'));
      await tester.pumpAndSettle();
      expect(find.text('Annonces populaires'), findsOneWidget);
    }
  });

  testWidgets('home displays multiple listings with local photos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Villa avec piscine'), findsOneWidget);
    expect(find.text('Villa familiale avec jardin'), findsOneWidget);
    expect(find.text('Résidence neuve S+3'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(4));
  });

  testWidgets('location selector updates the selected city', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Tunis'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir une ville'), findsOneWidget);
    expect(find.text('Utiliser ma position actuelle'), findsOneWidget);
    expect(find.text('Choisir sur la carte'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Sousse'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Sousse'));
    await tester.pumpAndSettle();

    expect(find.text('Sousse'), findsOneWidget);
    expect(find.text('Tunis'), findsNothing);
  });

  testWidgets('map picker returns a position to the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Tunis'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choisir sur la carte'));
    await tester.pumpAndSettle();

    expect(
      find.text('Touchez la carte pour déplacer le repère.'),
      findsOneWidget,
    );
    expect(find.text('Utiliser cette position'), findsOneWidget);

    await tester.tap(find.text('Utiliser cette position'));
    await tester.pumpAndSettle();

    expect(find.text('Position sur la carte'), findsOneWidget);
  });
}
