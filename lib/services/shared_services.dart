import 'dart:convert';
import 'dart:developer';

import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/auth/onboardingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  /* ----------------- Checks if the User is Loggend In or Not ---------------- */

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  /* ---------------------------- Saves Login Data ---------------------------- */

  static Future<void> setLoginDetails(LoginResponseModel? model, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_details", model != null ? jsonEncode(model.toJson()) : "");
    prefs.setString("user_id", uid);
  }

  /* ---------------------------- Fetch Login Data ---------------------------- */

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? LoginResponseModel.fromJson(jsonDecode(prefs.getString("login_details")!)) : LoginResponseModel();
  }

  /* ------------------------------ Fetch User ID ----------------------------- */

  static Future<String> userId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id") != null ? prefs.getString("user_id")! : "";
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

  /* ------------------------ Will Save Address of User ----------------------- */

  // static Future<void> setAddressDetails(Billing? billing) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString("address_details", billing != null ? jsonEncode(billing.toJson()) : "");
  // }

  /* ----------------------- Will Fetch Address of User ----------------------- */

  // static Future<Billing> addressDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("address_details") != null ? Billing.fromJson(jsonDecode(prefs.getString("address_details")!)) : Billing();
  // }

  /* ---------------------------- Save Cart Details --------------------------- */

  static Future<void> setCartDetails(List<CartDetails>? cart) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("cart_details", cart != null ? jsonEncode(cart.map((e) => e.toJson()).toList()) : "");
    log("Cart Details : stored");
  }

  /* --------------------------- Fetch Cart Detials --------------------------- */

  static Future<List<CartDetails>> cartDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("cart_details") != null ? (jsonDecode(prefs.getString("cart_details")!) as List).map((e) => CartDetails.fromJson(e)).toList() : [];
  }

  /* ---------------------------- Will Log Out User --------------------------- */

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cart_details");
    prefs.remove("login_details");
    prefs.remove("customer_details");
    // prefs.remove("address_details");
    prefs.remove("user_id");
    cartItems = [];
    cartCount.value = 0;
    prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) =>const OnboardingPage()),
      ModalRoute.withName('/'),
    );
  }
}
