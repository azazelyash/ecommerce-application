import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/splash_screen/splash_screen.dart';

// Widget defaultPage = const OnboardingPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final textTheme = GoogleFonts.dmSansTextTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // home: LoginUsingFirebase(),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(secondary: Colors.black, seedColor: const Color.fromRGBO(20, 120, 70, 1)),
        textTheme: textTheme(
          const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 20),
            titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
