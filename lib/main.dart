import 'package:abhyukthafoods/pages/auth/forgotpassword.dart';
import 'package:abhyukthafoods/pages/auth/loginpage.dart';
import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget defaultPage = const OnboardingPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // bool _result = await SharedService.isLoggedIn();

  // if (_result) {
  //   defaultPage = const MainPage();
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final textTheme = GoogleFonts.dmSansTextTheme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
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
