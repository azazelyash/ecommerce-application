import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          SearchTextfield(
            controller: searchController,
            onSearch: (p0) {},
          )
        ],
      ))),
    );
  }
}

class SearchTextfield extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;

  const SearchTextfield({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 360,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 10, 15, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  "assets/Icons/search-normal-.svg",
                  height: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.figtree(
                      color: Colors.grey.shade900,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "Search for Products...",
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    onChanged: onSearch,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    "assets/Icons/mic_24px.svg",
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}