import 'dart:convert';

import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/auth/onboardingpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null
        ? LoginResponseModel.fromJson(
            jsonDecode(prefs.getString("login_details")!),
          )
        : LoginResponseModel();
  }

  static Future<void> setLoginDetails(LoginResponseModel? model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_details", model != null ? jsonEncode(model.toJson()) : "");
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_details");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }
}
