import 'dart:developer';
import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/pages/profile/favouritepage.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'comps/navbar.dart';
import 'pages/auth/onboardingpage.dart';
import 'package:google_fonts/google_fonts.dart';

Widget defaultPage = OnboardingPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedService.isLoggedIn();

  if (_result) {
    defaultPage = MainPage();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final textTheme = GoogleFonts.dmSansTextTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: defaultPage,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            secondary: Colors.black,
            seedColor: const Color.fromRGBO(20, 120, 70, 1)),
        textTheme: textTheme(
          const TextTheme(
              bodyLarge: TextStyle(fontSize: 20),
              titleMedium:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }
}
