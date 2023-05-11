import 'package:abhyukthafoods/pages/profile/aboutuspage.dart';
import 'package:abhyukthafoods/pages/profile/favouritepage.dart';
import 'package:abhyukthafoods/pages/profile/languagepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../comps/dialogboxes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Text(
                "Profile",
                style: GoogleFonts.dmSans(
                    fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),

            // profile box
            ProfileBox(),

            // categories

            Titletile(
                imagepath: "assets/Icons/love.svg",
                title: "Favourites",
                onTapp: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FavouritePage(),
                    ),
                  );
                }),
            Titletile(
                imagepath: "assets/profile/fluent_location-16-regular.svg",
                title: "Addresses",
                onTapp: () {}),
            Titletile(
                imagepath: "assets/profile/uil_language.svg",
                title: "Choose Language",
                onTapp: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LanguagePage(),
                    ),
                  );
                }),
            Titletile(
                imagepath: "assets/profile/solar_settings-outline.svg",
                title: "Settings",
                onTapp: () {}),
            Titletile(
                imagepath: "assets/profile/mdi_about-circle-outline.svg",
                title: "About us",
                onTapp: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AboutUsPage(),
                    ),
                  );
                }),
            Titletile(
                imagepath: "assets/profile/tabler_help.svg",
                title: "Help desk",
                onTapp: () {}),
            Titletile(
                imagepath: "assets/profile/send feedback.svg",
                title: "Send Feedback",
                onTapp: () {}),
            Titletile(
                imagepath: "assets/profile/material-symbols_logout-rounded.svg",
                title: "Logout",
                onTapp: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MyAlertDialog(
                          content: 'Are you sure you want to Logout ?',
                          yes: () {});
                    },
                  );
                }),
          ],
        ),
      )),
    );
  }
}

class ProfileBox extends StatelessWidget {
  const ProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 370,
            height: 90,
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sri Nagesh",
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        "9894213456",
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        textScaleFactor: 1.0,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/profile/righwhite.svg",
                    height: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5)
      ],
    );
  }
}

class Titletile extends StatelessWidget {
  final String imagepath;
  final String title;
  final VoidCallback onTapp;

  const Titletile(
      {super.key,
      required this.imagepath,
      required this.title,
      required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      imagepath,
                      height: 22,
                    ),
                    SizedBox(width: 25),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
                SvgPicture.asset(
                  "assets/profile/material-symbols_chevron-right.svg",
                  height: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
