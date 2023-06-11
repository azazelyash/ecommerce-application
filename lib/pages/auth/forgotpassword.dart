import 'dart:developer';

import 'package:abhyukthafoods/pages/auth/loginpage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:flutter/material.dart';

import '../../comps/auth_text_field.dart';
import '../../comps/text_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.id});

  final int id;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool passwordUpdated = false;

  /* ----------------------------- Checks Validity ---------------------------- */

  bool arePasswordsMatching(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool isFilled(String password, String confirmPassword) {
    return password.isNotEmpty && confirmPassword.isNotEmpty;
  }

  /* ----------------------------- Update Password ---------------------------- */

  void updatePassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    passwordUpdated = await APIService.updatePassword(passwordController.text, widget.id.toString());
    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password Updated Successfully"),
        backgroundColor: Colors.green,
      ),
    );

    if (passwordUpdated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
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
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: resetPasswordBody(context),
          ),
        ),
      ],
    );
  }

  Widget resetPasswordBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Enter New Password",
                style: kauthTextFieldStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Please enter your new password below",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: authTextFieldDecoration("Password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmpasswordController,
              style: const TextStyle(color: Colors.white),
              decoration: authTextFieldDecoration("Confirm Password"),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (!isFilled(passwordController.text, confirmpasswordController.text)) {
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
                } else if (!arePasswordsMatching(passwordController.text, confirmpasswordController.text)) {
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
                          Text("Passwords do not match"),
                        ],
                      ),
                    ),
                  );
                } else {
                  updatePassword();
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
                    "Change Password",
                    style: kauthTextFieldStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textScaleFactor: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
