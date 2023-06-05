import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StandardAppBar(title: "About Us"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            const Image(
              image: AssetImage("assets/app_logo/logo.png"),
              height: 200,
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "India's largest Pickles store",
                      style: GoogleFonts.dmSans(color: Colors.grey.shade600, fontSize: 17, fontWeight: FontWeight.w700),
                      textScaleFactor: 1.0,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Abhyukta Foods is a reliable and reputed site where you can order pickles online and also can get your desired items at your home only. You don’t need to go anywhere as it is available online.",
                        style: GoogleFonts.dmSans(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "Privacy Policy         |         Terms & Conditions",
                        style: GoogleFonts.dmSans(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
