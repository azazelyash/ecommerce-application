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


class HomeAppBar extends StatefulWidget with PreferredSizeWidget {
  HomeAppBar({
    required this.title,
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  final String title;
  @override
  final Size preferredSize;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      backgroundColor: Colors.white,
      title: const Text(
        'Hello! Manikanta',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          color: Colors.black,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 10),
          child: CircleAvatar(
              // backgroundImage: NetworkImage(''),
              ),
        )
      ],
    );
  }
}
