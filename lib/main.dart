import 'dart:developer';

import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/pages/profile/favouritepage.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'pages/auth/onboardingpage.dart';
import 'comps/navbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: defaultPage,
    );
  }
}
