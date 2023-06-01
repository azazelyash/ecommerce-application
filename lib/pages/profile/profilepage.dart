import 'dart:developer';

import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/profile/aboutuspage.dart';
import 'package:abhyukthafoods/pages/profile/address_page.dart';
import 'package:abhyukthafoods/pages/profile/favouritepage.dart';
import 'package:abhyukthafoods/pages/profile/languagepage.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../comps/dialogboxes.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.customerModel});

  CustomerModel? customerModel = CustomerModel();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CustomerModel? customerModel = CustomerModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerModel = widget.customerModel;
    log(customerModel!.toJson().toString());
  }

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
                style: GoogleFonts.dmSans(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),

            // profile box
            ProfileBox(
              customerModel: customerModel,
            ),

            // categories

            Titletile(
                imagepath: "assets/Icons/love.svg",
                title: "Favourites",
                onTapp: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FavouritePage(),
                    ),
                  );
                }),
            Titletile(
              imagepath: "assets/profile/fluent_location-16-regular.svg",
              title: "Addresses",
              onTapp: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddressPage(
                      id: customerModel!.id.toString(),
                    ),
                  ),
                );
              },
            ),

            /* -------------------------- Choose Language Tile -------------------------- */

            // Titletile(
            //   imagepath: "assets/profile/uil_language.svg",
            //   title: "Choose Language",
            //   onTapp: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (_) => const LanguagePage(),
            //       ),
            //     );
            //   },
            // ),

            /* ------------------------------ Settings Tile ----------------------------- */

            // Titletile(
            //   imagepath: "assets/profile/solar_settings-outline.svg",
            //   title: "Settings",
            //   onTapp: () {},
            // ),
            Titletile(
              imagepath: "assets/profile/mdi_about-circle-outline.svg",
              title: "About us",
              onTapp: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AboutUsPage(),
                  ),
                );
              },
            ),

            /* ------------------------------ Settings Tile ----------------------------- */

            // Titletile(
            //   imagepath: "assets/profile/tabler_help.svg",
            //   title: "Help desk",
            //   onTapp: () {},
            // ),

            /* --------------------------- Send Feedback Tiles -------------------------- */

            // Titletile(
            //   imagepath: "assets/profile/send feedback.svg",
            //   title: "Send Feedback",
            //   onTapp: () {},
            // ),
            Titletile(
                imagepath: "assets/profile/material-symbols_logout-rounded.svg",
                title: "Logout",
                onTapp: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MyAlertDialog(
                        content: 'Are you sure you want to Logout ?',
                        yes: () {
                          SharedService.logout(context);
                        },
                      );
                    },
                  );
                }),
          ],
        ),
      )),
    );
  }
}

class ProfileBox extends StatefulWidget {
  ProfileBox({super.key, required this.customerModel});

  CustomerModel? customerModel;

  @override
  State<ProfileBox> createState() => _ProfileBoxState();
}

class _ProfileBoxState extends State<ProfileBox> {
  CustomerModel? model = CustomerModel();

  @override
  void initState() {
    super.initState();
    model = widget.customerModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            // height: 74,

            /* ------------------------------ Profile Color ----------------------------- */

            decoration: BoxDecoration(color: const Color(0xff147846), borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          model!.avatarUrl ?? '',
                          height: 52,
                          width: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${model!.firstname} ${model!.lastname}",
                            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          Text(
                            model!.email!,
                            style: GoogleFonts.dmSans(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500),
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}

class Titletile extends StatelessWidget {
  final String imagepath;
  final String title;
  final VoidCallback onTapp;

  const Titletile({super.key, required this.imagepath, required this.title, required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Container(
        color: Colors.transparent,
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
      ),
    );
  }
}
