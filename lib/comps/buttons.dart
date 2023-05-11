import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RectButton extends StatelessWidget {
  final String title;
  final VoidCallback onTapp;
  const RectButton({super.key, required this.title, required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Container(
          width: 390,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textScaleFactor: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
