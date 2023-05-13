import 'dart:developer';

import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/auth/loginpage.dart';
import 'package:abhyukthafoods/comps/auth_text_field.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/homepage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  APIService apiService = APIService();
  bool signedIn = false;
  String firstName = '';
  String lastName = '';

  /* ---------------------------- Splits Full Name ---------------------------- */

  void separateFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length > 1) {
      firstName = nameParts[0];
      lastName = nameParts.last;
      log('First Name: $firstName');
      log('Last Name: $lastName');
    } else {
      firstName = fullName;
      lastName = " ";
    }
  }

  /* ----------------------------- Checks Validity ---------------------------- */

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool arePasswordsMatching(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool isFilled(
      String email, String password, String confirmPassword, String name) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        name.isNotEmpty;
  }

  /* ------------------------------ Sign Up User ------------------------------ */

  Future<void> signUp(CustomerModel model) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final success = await apiService.createCustomer(model);

    Navigator.of(context).pop(); // Close the dialog

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Sign Up Successful"),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainPage(), // Replace with your homepage widget
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Email Already Exists"),
        ),
      );
    }
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
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),

                    //textfields
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Email Id"),
                      ),
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
                        controller: cfmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Confirm Password"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Name"),
                      ),
                    ),

                    //info
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "By signing up, you are agreeing to our Terms & Conditions, Privacy Policy.",
                          textAlign: TextAlign.center,
                          style: kauthTextFieldStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),

                    /* ------------------------------ SignUp Button ----------------------------- */

                    //buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (!isFilled(
                              emailController.text,
                              passwordController.text,
                              cfmPasswordController.text,
                              nameController.text)) {
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
                                    Text("Email is Invalid"),
                                  ],
                                ),
                              ),
                            );
                          } else if (!arePasswordsMatching(
                              passwordController.text,
                              cfmPasswordController.text)) {
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
                            separateFullName(nameController.text);
                            CustomerModel model = CustomerModel(
                              email: emailController.text,
                              password: passwordController.text,
                              firstname: firstName,
                              lastname: lastName,
                            );
                            signUp(model);
                            // log(emailController.text);
                            // log(passwordController.text);
                            // log(nameController.text);
                            // log(cfmPasswordController.text);
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
                              "Sign Up",
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

                    //login with
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sign up with",
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),

                    //Google and facebox button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GoogleButton(onTapp: () {}),
                        FacebookButton(onTapp: () {})
                      ],
                    ),

                    //other way
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account ? ",
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
                                  builder: (_) => LoginPage(),
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

class GoogleButton extends StatelessWidget {
  final VoidCallback onTapp;
  const GoogleButton({super.key, required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/Login-signup/google.svg",
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class FacebookButton extends StatelessWidget {
  final VoidCallback onTapp;
  const FacebookButton({super.key, required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/Login-signup/facebook.svg",
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
