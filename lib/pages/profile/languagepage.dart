import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../comps/buttons.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = "English"; // Set default value to English
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StandardAppBar(title: "Languages"),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customRadioListTile(
                      title: "Hindi",
                      value: "Hindi",
                    ),
                    const Divider(),
                    customRadioListTile(
                      title: "English",
                      value: "English",
                    ),
                    const Divider(),
                    customRadioListTile(
                      title: "Telugu",
                      value: "Telugu",
                    ),
                  ],
                ),
              ),
              RectButton(
                title: 'Save Changes',
                onTapp: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRadioListTile({required String title, required String value}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.0,
            ),
            selectedLanguage == value
                ? SvgPicture.asset(
                    "assets/Icons/teenyicons_tick-circle-solid.svg",
                    height: 22,
                  )
                : SvgPicture.asset(
                    "assets/Icons/Ellipse 1218.svg",
                    height: 22,
                  ),
          ],
        ),
      ),
    );
  }
}
