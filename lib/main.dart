import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/pages/profile/favouritepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'pages/auth/onboardingpage.dart';
import 'comps/navbar.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}
