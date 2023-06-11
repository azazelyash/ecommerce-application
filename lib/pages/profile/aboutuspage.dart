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
                      style: GoogleFonts.dmSans(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w700),
                      textScaleFactor: 1.0,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Abhyuktha Traditional Foods is a well-known brand that specializes in making homemade veg and non-veg pickles, sweets, and powders.",
                        style: GoogleFonts.dmSans(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "Privacy Policy       |       Terms & Conditions",
                        style: GoogleFonts.dmSans(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
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
