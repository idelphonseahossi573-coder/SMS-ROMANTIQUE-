import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SmsRomantiqueApp());
}

class SmsRomantiqueApp extends StatelessWidget {
  const SmsRomantiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    const rose = Color(0xFFE94F7B);
    const roseFonce = Color(0xFFB5324F);
    const fondCreme = Color(0xFFFFF7F8);

    return MaterialApp(
      title: 'SMS Romantique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fondCreme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: rose,
          primary: rose,
          secondary: roseFonce,
        ),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: rose,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: rose,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
