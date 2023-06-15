import 'dart:developer';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/profile/profilepage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape_small.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StandardAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  final String title;
  @override
  final Size preferredSize;

  String htmlParser(String title) {
    HtmlUnescape unescape = HtmlUnescape();
    String data = unescape.convert(title);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        child: Container(
            margin: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          height: 0.5,
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        htmlParser(title),
        textScaleFactor: 1.0,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

/* ----------------------------- HomePage AppBar ---------------------------- */

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key, required this.customerModel})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final CustomerModel? customerModel;

  @override
  final Size preferredSize;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  CustomerModel? customerModel;
  LoginResponseModel? loginModel;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    customerModel = widget.customerModel;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.3,
      backgroundColor: Colors.white,
      title: Text(
        "Hello! ${customerModel?.firstname.toString()}",
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      actions: [
        /* --------------------------- Notification Button -------------------------- */

        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Icon(
        //     Icons.notifications_none_outlined,
        //     color: Colors.black,
        //   ),
        // ),

        /* ----------------------------- Profile Button ----------------------------- */

        Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    customerModel: customerModel!,
                    rerouteIndex: 4,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(customerModel!.avatarUrl.toString()),
            ),
          ),
        ),
      ],
    );
  }
}

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget {
  AddressAppBar({super.key, required this.title}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  String title;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.3,
      leading: GestureDetector(
        child: Container(
            margin: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  PaymentAppBar({super.key, required this.title}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  String title;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.3,
      leading: GestureDetector(
        child: Container(
            margin: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
