import 'dart:developer';

import 'package:abhyukthafoods/comps/auth_text_field.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/auth/enter_otp_page.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:flutter/material.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController emailController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isFieldEmpty(String field) {
    return field.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: const AssetImage("assets/forgot_password/Background.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: otpVerificationScreen(),
        ),
      ],
    );
  }

  Widget otpVerificationScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "OTP Verification",
                style: kauthTextFieldStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Enter your registered email address",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: authTextFieldDecoration("Email"),
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () async {
              if (isFieldEmpty(emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("All fields are Mandatory"),
                      ],
                    ),
                  ),
                );
              } else if (!isValidEmail(emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Invalid Email"),
                      ],
                    ),
                  ),
                );
              } else {
                showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
                log("Entered Email : ${emailController.text}");
                dynamic isValid = await APIService.verifyEmail(emailController.text);

                if (!mounted) return;

                Navigator.pop(context);

                if (isValid != null) {
                  log("Sending OTP...");
                  log("Id : ${isValid['id']}");
                  log("Email : ${isValid['email']}");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EnterOTPScreen(
                        id: isValid['id'],
                        email: isValid['email'],
                      ),
                    ),
                  );
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Email is not registered"),
                        ],
                      ),
                    ),
                  );
                }
              }
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
                  "Request OTP",
                  style: kauthTextFieldStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
