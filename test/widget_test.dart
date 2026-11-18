// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immofinder/main.dart';
import 'package:immofinder/screens/profile_screen.dart';
import 'package:immofinder/user_profile_store.dart';

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

    expect(find.text('Leila Trabelsi'), findsOneWidget);
    expect(find.text('leila@example.com'), findsOneWidget);
    expect(find.text('+216 55 123 456'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    profileStore.clear();
  });
}
