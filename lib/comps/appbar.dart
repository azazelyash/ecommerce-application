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

class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StandardAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  final String title;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: const BorderRadius.all(Radius.circular(100))),
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
          textScaleFactor: 1.3,
          style: const TextStyle(color: Colors.black),
        ));
  }
}

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
          // child: FutureBuilder(
          //   future: SharedService.loginDetails(),
          //   builder: (context, AsyncSnapshot<LoginResponseModel> loginModel) {
          //     if (loginModel.hasData) {
          //       return FutureBuilder(
          //         future: APIService.getCustomerDetails(loginModel.data!.data!.id.toString()),
          //         builder: (context, AsyncSnapshot<CustomerModel?> snapshot) {
          //           if (loginModel.hasData) {
          //             return CircleAvatar(
          //               backgroundImage: NetworkImage(snapshot.data!.avatarUrl.toString()),
          //             );
          //           } else {
          //             return const Center(child: CircularProgressIndicator());
          //           }
          //         },
          //       );
          //     } else {
          //       return const Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),
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
              Navigator.pop(context, true);
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
      backgroundColor: Colors.white,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
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
