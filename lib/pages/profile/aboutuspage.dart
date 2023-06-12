import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/pages/policies_page/privacy_policy.dart';
import 'package:abhyukthafoods/pages/policies_page/refund_policy.dart';
import 'package:abhyukthafoods/pages/policies_page/return_policy.dart';
import 'package:abhyukthafoods/pages/policies_page/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StandardAppBar(title: "About Us"),
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicy(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "|",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const TermsCondition(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RefundPolicy(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Refund Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "|",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ReturnPolicy(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Return Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
