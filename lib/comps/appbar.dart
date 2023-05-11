import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class MyAppbar2 extends StatelessWidget {
  const MyAppbar2({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              "assets/Icons/back.svg",
              height: 30,
            ),
          ),
          SizedBox(width: 18),
          Text(
            title,
            style:
                GoogleFonts.dmSans(fontSize: 25, fontWeight: FontWeight.w700),
            textScaleFactor: 1.0,
          ),
        ],
      ),
    );
  }
}
