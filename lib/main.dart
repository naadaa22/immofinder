import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'language_store.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ImmoFinderApp());
}

class ImmoFinderApp extends StatelessWidget {
  const ImmoFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LanguageStore.instance,
      builder: (context, _) {
        final language = LanguageStore.instance;
        return Directionality(
          textDirection: language.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: MaterialApp(
            title: 'ImmoFinder',
            locale: language.locale,
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'US'),
              Locale('ar', 'TN'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF4B2A8B),
              scaffoldBackgroundColor: Colors.white,
              textTheme: Theme.of(context).textTheme,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4B2A8B),
              ),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF4B2A8B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF8E8E93);
  static const Color white = Colors.white;
}
