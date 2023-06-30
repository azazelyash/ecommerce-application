import 'dart:async';
import 'dart:developer';

import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/auth/firebase_otp_verification.dart';
import 'package:abhyukthafoods/pages/auth/login_using_firebase.dart';
import 'package:abhyukthafoods/pages/auth/loginpage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class OTPSignupPage extends StatefulWidget {
  const OTPSignupPage({super.key});

  @override
  State<OTPSignupPage> createState() => _OTPSignupPageState();
}

class _OTPSignupPageState extends State<OTPSignupPage> {
  String? phoneNumber;
  String? countryCode;

  bool isPhoneFieldFilled(String? text) {
    if (text == null || text == "") {
      return false;
    }
    return true;
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
                          "Sign Up here",
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntlPhoneField(
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "By signing up, you are agreeing to our Terms & Conditions, Privacy Policy.",
                          textAlign: TextAlign.center,
                          style: kauthTextFieldStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
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
                              const SnackBar(
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
                          log("Phone Number: $phone");
                          loadingIndicator(context);
                          await APIService().firebasePhoneAuth(phone, context);
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

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account ? ",
                            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LoginUsingFirebase(),
                                ),
                              );
                            },
                            child: Text(
                              "Login Here",
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
