import 'dart:developer';

import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/auth/forgotpassword.dart';
import 'package:abhyukthafoods/pages/auth/loginpage.dart';
import 'package:abhyukthafoods/pages/auth/otp_verification.dart';

import 'package:abhyukthafoods/pages/auth/signuppage.dart';
import 'package:abhyukthafoods/comps/auth_text_field.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/home/homepage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CustomerModel? customerModel = CustomerModel();

  /* ----------------------- Check Username and Password ---------------------- */

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isFieldEmpty(String field) {
    return field.isEmpty;
  }

  /* ------------------------------- User Login ------------------------------- */

  Future<void> loginUser() async {
    loadingIndicator(context);

    // LoginResponseModel model = await APIService.loginCustomer(
    //   emailController.text,
    //   passwordController.text,
    // );
    // getCustomerData();

    // // if (!mounted) return;

    // Navigator.of(context).pop();

    // if (model.statusCode == 200) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (_) => MainPage(customerModel: customerModel!), // Replace with your homepage widget
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text("Invalid Username or Password"),
    //     ),
    //   );
    // }
  }

  Future<void> getCustomerData() async {
    customerModel = await SharedService.customerDetails();
    /* -------------------------- print customer model -------------------------- */
    log("Customer Model: ${customerModel!.toJson()}");
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
                          style: kauthTextFieldStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                        decoration: authTextFieldDecoration("Email"),
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

                    /* ----------------------------- Forgot Password ---------------------------- */

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const OTPVerification(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password",
                              style: kauthTextFieldStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /* ------------------------------ Login Button ------------------------------ */

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (isFieldEmpty(emailController.text) || isFieldEmpty(passwordController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
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
                            loginUser();
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
                              "Login in",
                              style: kauthTextFieldStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //login with
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       "Login with",
                    //       style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    //       textScaleFactor: 1.0,
                    //     ),
                    //   ),
                    // ),

                    // //Google and facebox button
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [GoogleButton(onTapp: () {}), FacebookButton(onTapp: () {})],
                    // ),

                    //other way
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account ? ",
                            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignUpPage(),
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
