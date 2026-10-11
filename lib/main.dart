import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const ColoringWorldApp());
}

class ColoringWorldApp extends StatelessWidget {
  const ColoringWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coloring World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      ),
      home: const SplashScreen(),
    );
  }
}