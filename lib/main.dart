import 'package:abhyukthafoods/pages/auth/onboardingpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final textTheme = GoogleFonts.dmSansTextTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            secondary: Colors.black,
            seedColor: const Color.fromRGBO(20, 120, 70, 1)),
        textTheme: textTheme(
          const TextTheme(
              bodyLarge: TextStyle(fontSize: 20),
              titleMedium:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}
