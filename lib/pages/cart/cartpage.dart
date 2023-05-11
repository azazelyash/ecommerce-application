import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // title
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Text(
                "Cart",
                style: GoogleFonts.dmSans(
                    fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
