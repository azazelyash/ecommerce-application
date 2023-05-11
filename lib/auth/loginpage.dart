import 'package:abhyukthafoods/auth/loginpage.dart';
import 'package:abhyukthafoods/auth/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    //info
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Remember Me",
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          Text(
                            "Forgot Password",
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                    ),

                    //buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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

                    //login with
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login with",
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
                            "Don't have an account ? ",
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SignUpPage(),
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
