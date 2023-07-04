import 'dart:developer';

import 'package:abhyukthafoods/comps/auth_text_field.dart';
import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/auth/otp_signup_page.dart';
import 'package:abhyukthafoods/pages/auth/otp_verification.dart';
import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_otp_verification.dart';

class LoginUsingFirebase extends StatelessWidget {
  LoginUsingFirebase({super.key});
  TextEditingController phoneController = TextEditingController();

  /* ----------------------- Check Username and Password ---------------------- */

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isFieldEmpty(String field) {
    return field.isEmpty;
  }

  String? phoneNumber;
  String? countryCode;

  bool isPhoneFieldFilled(String? text) {
    if (text == null || text == "") {
      return false;
    }
    return true;
  }

  Future<void> checkPhoneNumberExists(
      BuildContext context, String phone) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("Phone number exist");
        firebasePhoneLogin(phone, context);
      } else {
        log("Phone number does not exist");
        // Phone number doesn't exist, show a dialog box
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Phone Number Not Found"),
              content:
                  Text("The phone number is not registered. Please sign up."),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OTPSignupPage()),
                            ModalRoute.withName('/'));
                      },
                      child: Text("SignUp Here"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      log("Error checking phone number exists: ${e.toString()}");
      // Show a dialog box with the error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred. Please try again later."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> firebasePhoneLogin(
      String phoneNumber, BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        log("Phone Auth Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.of(context).pop();
        log("Phone Auth Failed: ${e.message}");
      },
      codeSent: (String verificationID, int? resendToken) async {
        log("Code Sent");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginOTPVerificationPage(
              verificationId: verificationID,
              phone: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/Icons/bgg.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    //title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login here",
                          style: kauthTextFieldStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),
                    //textfields
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntlPhoneField(
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        dropdownTextStyle: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        disableLengthCheck: true,
                        dropdownIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          phoneNumber = value.number.toString();
                          countryCode = value.countryCode.toString();
                        },
                        dropdownIconPosition: IconPosition.trailing,
                        showCountryFlag: false,
                        flagsButtonPadding: const EdgeInsets.only(left: 8),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /* ------------------------------ SignUp Button ----------------------------- */

                    //buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (!isPhoneFieldFilled(phoneNumber)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("Enter Phone Number"),
                                  ],
                                ),
                              ),
                            );
                            return;
                          }

                          String phone = countryCode! + phoneNumber!;
                          loadingIndicator(context);
                          checkPhoneNumberExists(context, phone);

                          // Check if the phone number exists in Firestore
                        },
                        child: Container(
                          width: 390,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              "Send OTP",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //other way
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account ? ",
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const OTPSignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Signup Here",
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
