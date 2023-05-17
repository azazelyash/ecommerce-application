import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../models/products.dart';
class APIConfig {
  String url = "https://www.mrsfood.in/wp-json/wc/v3/";
  String loginUrl = "https://www.mrsfood.in";
  String tokenUrl = "https://www.mrsfood.in/wp-json/jwt-auth/v1/token";
  String key = "ck_e199fec7666dea64b4661cd48fa6a72719bc9004";
  String secret = "cs_c6f4f6cb07505bb7b0d4926fc519f80db8352cd1";
  String customerURl = "customers";
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final APIConfig apiConfig = APIConfig();
  final TextEditingController searchController = TextEditingController();
  List<Product> products = [];

  Future<void> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse("${apiConfig.url}products?search=$query"),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${apiConfig.key}:${apiConfig.secret}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        products = jsonList.map((e) => Product.fromJson(e)).toList();
      });
    } else {
      // Handle the error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SearchTextfield(
                controller: searchController,
                onSearch: searchProducts,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(
                      product.name,
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
