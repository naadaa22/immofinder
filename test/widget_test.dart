// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart'
    as geocoding;
import 'package:immofinder/main.dart';
import 'package:immofinder/screens/home_screen.dart';
import 'package:immofinder/screens/login_screen.dart';
import 'package:immofinder/screens/favorites_screen.dart';
import 'package:immofinder/screens/listing_details_screen.dart';
import 'package:immofinder/screens/profile_screen.dart';
import 'package:immofinder/screens/privacy_screen.dart';
import 'package:immofinder/screens/register_screen.dart';
import 'package:immofinder/user_profile_store.dart';

void main() {
  geocoding.GeocodingPlatformFactory.instance = _FakeGeocodingPlatformFactory();

  testWidgets('shows splash screen then opens login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ImmoFinderApp());

    expect(find.text('Immofinder'), findsOneWidget);
    expect(find.text('Find Your Dream Here'), findsOneWidget);
    expect(find.text('Connectez-vous pour continuer'), findsNothing);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Connectez-vous pour continuer'), findsOneWidget);
  });

  testWidgets('shows the signed-in user details in the profile', (
    WidgetTester tester,
  ) async {
    final profileStore = UserProfileStore.instance;
    profileStore.register(
      name: 'Leila Trabelsi',
      email: 'leila@example.com',
      phone: '+216 55 123 456',
    );

    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('Informations personnelles'), findsOneWidget);
    await tester.tap(find.text('Informations personnelles'));
    await tester.pumpAndSettle();

    expect(find.text('Leila Trabelsi'), findsOneWidget);
    expect(find.text('leila@example.com'), findsOneWidget);
    expect(find.text('+216 55 123 456'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    profileStore.clear();
  });

  testWidgets('opens the privacy policy from the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.scrollUntilVisible(
      find.text('Politique de confidentialité'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Politique de confidentialité'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyScreen), findsOneWidget);
    expect(find.text('Votre vie privée compte'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Localisation et carte'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Localisation et carte'), findsOneWidget);
  });

  testWidgets('password visibility buttons toggle login and registration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final loginPassword = find.byType(TextField).at(1);
    expect(tester.widget<TextField>(loginPassword).obscureText, isTrue);
    await tester.tap(find.byTooltip('Afficher le mot de passe'));
    await tester.pump();
    expect(tester.widget<TextField>(loginPassword).obscureText, isFalse);

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    final registrationPassword = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.hintText == 'Mot de passe',
    );
    expect(tester.widget<TextField>(registrationPassword).obscureText, isTrue);
    await tester.tap(find.byTooltip('Afficher le mot de passe').first);
    await tester.pump();
    expect(tester.widget<TextField>(registrationPassword).obscureText, isFalse);
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
      } else if (category == 'Terrain') {
        expect(find.text('Parcelle agricole de 2 hectares'), findsOneWidget);
        expect(find.text('Terrain avec vue panoramique'), findsOneWidget);
      } else {
        expect(
          find.text('Aucune annonce disponible pour cette catégorie.'),
          findsOneWidget,
        );
      }

      await tester.tap(find.text('Tout voir'));
      await tester.pumpAndSettle();
      expect(find.text('Featured Properties'), findsOneWidget);
    }
  });

  testWidgets('home displays initial listings with local photos', (
    WidgetTester tester,
  ) async {
    UserProfileStore.instance.register(
      name: 'Leila Trabelsi',
      email: 'leila@example.com',
      phone: '',
    );
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Hello, Leila Trabelsi!'), findsOneWidget);
    expect(find.text('Villa avec piscine'), findsOneWidget);
    expect(find.text('Villa familiale avec jardin'), findsOneWidget);
    expect(find.text('Résidence neuve S+3'), findsOneWidget);
    expect(find.byType(Image), findsAtLeastNWidgets(4));
  });

  testWidgets('client can add and remove a home listing from favorites', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final favoriteKey = find.byKey(
      const ValueKey('favorite-Villa avec piscine'),
    );
    await tester.ensureVisible(favoriteKey);
    await tester.tap(favoriteKey);
    await tester.pump();

    expect(
      find.descendant(of: favoriteKey, matching: find.byIcon(Icons.favorite)),
      findsOneWidget,
    );

    await tester.tap(favoriteKey);
    await tester.pump();
    expect(
      find.descendant(
        of: favoriteKey,
        matching: find.byIcon(Icons.favorite_border),
      ),
      findsOneWidget,
    );
  });

  testWidgets('voir tout reveals additional home listings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Appartement moderne S+3'), findsNothing);
    await tester.tap(find.text('Voir tout >'));
    await tester.pumpAndSettle();

    expect(find.text('Appartement moderne S+3'), findsOneWidget);
    expect(find.text('Studio meublé en centre-ville'), findsOneWidget);
    expect(find.text('Appartement neuf S+2'), findsOneWidget);
    expect(find.text('Terrain constructible'), findsOneWidget);
    expect(find.text('Voir moins'), findsOneWidget);
  });

  testWidgets('tapping a home listing opens its details', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.ensureVisible(find.text('Appartement S+2'));
    await tester.tap(find.text('Appartement S+2'));
    await tester.pumpAndSettle();

    expect(find.byType(ListingDetailsScreen), findsOneWidget);
    expect(find.text('250 000 DT'), findsOneWidget);
    expect(find.text('À La Marsa'), findsOneWidget);
    expect(find.text('2 chambres'), findsOneWidget);
    expect(find.text('120 m²'), findsOneWidget);
    expect(
      find.text('Appartement S+2 de 120 m² situé à La Marsa.'),
      findsOneWidget,
    );
  });

  testWidgets('tapping a favorite listing opens its details', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FavoritesScreen()));

    await tester.tap(find.text('Appartement S+2'));
    await tester.pumpAndSettle();

    expect(find.byType(ListingDetailsScreen), findsOneWidget);
    expect(find.text('250 000 DT'), findsOneWidget);
    expect(find.text('La Marsa, Tunis'), findsOneWidget);
    expect(find.text('2 chambres'), findsOneWidget);
    expect(find.text('120 m²'), findsOneWidget);
  });

  testWidgets('location selector offers map and current position only', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Localisation'), findsOneWidget);
    expect(find.text('Tunis'), findsNothing);
    await tester.tap(find.text('Localisation'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir une localisation'), findsOneWidget);
    expect(find.text('Utiliser ma position actuelle'), findsOneWidget);
    expect(find.text('Choisir sur la carte'), findsOneWidget);
    expect(find.text('Sousse'), findsNothing);
  });

  testWidgets('map picker returns a position to the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Localisation'));
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

    expect(find.text('La Marsa'), findsOneWidget);
  });
}

class _FakeGeocodingPlatformFactory extends geocoding.GeocodingPlatformFactory {
  @override
  geocoding.Geocoding createGeocoding(
    geocoding.GeocodingCreationParams params,
  ) {
    return _FakeGeocoding(params);
  }
}

class _FakeGeocoding extends geocoding.Geocoding {
  _FakeGeocoding(super.params) : super.implementation();

  @override
  Future<List<geocoding.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    Locale? locale,
  }) async {
    return const [geocoding.Placemark(locality: 'La Marsa')];
  }
}
