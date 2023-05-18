import 'dart:convert';
import 'dart:developer';

import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/auth/onboardingpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  /* ----------------- Checks if the User is Loggend In or Not ---------------- */

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  /* ---------------------------- Saves Login Data ---------------------------- */

  static Future<void> setLoginDetails(LoginResponseModel? model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_details", model != null ? jsonEncode(model.toJson()) : "");
  }

  /* ---------------------------- Fetch Login Data ---------------------------- */

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? LoginResponseModel.fromJson(jsonDecode(prefs.getString("login_details")!)) : LoginResponseModel();
  }

  /* ------------------------- Will Save Customer Data ------------------------ */

  static Future<void> setCustomerDetails(CustomerModel? model) async {
    final prefs = await SharedPreferences.getInstance();
    log("Avatar Url at Shared Service : ${model!.avatarUrl}");
    prefs.setString("customer_details", model != null ? jsonEncode(model.toJson()) : "");
  }

  /* ------------------------- Will Fetch Customer Data ------------------------ */

  static Future<CustomerModel> customerDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("customer_details") != null ? CustomerModel.fromJson(jsonDecode(prefs.getString("customer_details")!)) : CustomerModel();
  }

  /* ---------------------------- Will Log Out User --------------------------- */

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_details");
    prefs.remove("customer_details");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }
}
