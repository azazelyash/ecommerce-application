import 'dart:async';
import 'dart:developer';

import 'package:abhyukthafoods/comps/internetlostpage.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/cart/cartpage.dart';
import 'package:abhyukthafoods/pages/orders/orderspage.dart';
import 'package:abhyukthafoods/pages/profile/profilepage.dart';
import 'package:abhyukthafoods/pages/search/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../pages/home/homepage.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  CustomerModel? model = CustomerModel();
  bool isConnected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = widget.customerModel;
  }

  void navigateBottomBar(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(customerModel: model),
      SearchPage(),
      CartPage(customerModel: model!),
      OrdersPage(customerModel: model),
      ProfilePage(customerModel: model),
    ];

    return Scaffold(
        bottomNavigationBar: NavBox(
          onTap: (index) => navigateBottomBar(index),
          index: selectedIndex,
        ),
        body: StreamBuilder(
          stream: InternetConnectionChecker().onStatusChange,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case InternetConnectionStatus.disconnected:
                return LostInternet(callback: () {
                  setState(() {
                    log('aaaaa');
                  });
                });
              case null:
              case InternetConnectionStatus.connected:
                return _pages[selectedIndex];
            }
          },
        ));
  }
}

class NavBox extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const NavBox({
    Key? key,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 87,
      decoration: BoxDecoration(
        color: Color(0xff1D1F24),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                onTap(0);
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/Icons/home-2-${index == 0 ? 'white' : 'color'}.svg",
                    height: 25,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Home",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: index == 0 ? Colors.white : Colors.grey,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(1);
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/Icons/search-normal-${index == 1 ? 'white' : 'color'}.svg",
                    height: 25,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Search",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: index == 1 ? Colors.white : Colors.grey,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(2);
              },
              child: Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: const Color(0xff147846),
                  // color: index == 2 ? Color(0xff147846) : Colors.green.shade300,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/Icons/Vector-only cart-white.svg",
                    height: 20,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(3);
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/Icons/clock-${index == 3 ? 'white' : 'color'}.svg",
                    height: 25,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Orders",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: index == 3 ? Colors.white : Colors.grey,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                onTap(4);
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/Icons/user-${index == 4 ? 'white' : 'color'}.svg",
                    height: 25,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Profile ",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: index == 4 ? Colors.white : Colors.grey,
                    ),
                    textScaleFactor: 1.0,
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
