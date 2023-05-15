import 'package:abhyukthafoods/pages/cart/cartpage.dart';
import 'package:abhyukthafoods/pages/orders/orderspage.dart';
import 'package:abhyukthafoods/pages/profile/profilepage.dart';
import 'package:abhyukthafoods/pages/search/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/home/homepage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  void navigateBottomBar(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
     SearchPage(),
    const CartPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBox(
        onTap: (index) => navigateBottomBar(index),
        index: selectedIndex,
      ),
      body: _pages[selectedIndex],
    );
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
        color: Colors.grey[850],
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
                    color: index == 2
                        ? Colors.green.shade300
                        : Colors.green.shade300,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white)),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/Icons/cart.svg",
                    height: 25,
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
