import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ImmoFinderApp());
}

class ImmoFinderApp extends StatelessWidget {
  const ImmoFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImmoFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B2A8B),
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B2A8B)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
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