import 'dart:developer';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 18),
          Text(
            title,
            style: GoogleFonts.dmSans(fontSize: 25, fontWeight: FontWeight.w700),
            textScaleFactor: 1.0,
          ),
        ],
      ),
    );
  }
}

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar({Key? key, required this.customerModel})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  CustomerModel? customerModel;

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
    // TODO: implement initState
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
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(customerModel!.avatarUrl.toString()),
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
      backgroundColor: Colors.white,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 18),
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
