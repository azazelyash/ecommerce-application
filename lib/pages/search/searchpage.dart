import 'dart:convert';
import 'package:abhyukthafoods/pages/product_page/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class APIConfig {
  String url = "https://www.mrsfood.in/wp-json/wc/v3/";
  String loginUrl = "https://www.mrsfood.in";
  String tokenUrl = "https://www.mrsfood.in/wp-json/jwt-auth/v1/token";
  String key = "ck_e199fec7666dea64b4661cd48fa6a72719bc9004";
  String secret = "cs_c6f4f6cb07505bb7b0d4926fc519f80db8352cd1";
  String customerURl = "customers";
}

class Product {
  final String name;

  Product({required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
    );
  }
}

class API {
  static Future<List<Product>> searchProducts(String query) async {
    final APIConfig apiConfig = APIConfig();
    final response = await http.get(
      Uri.parse("${apiConfig.url}products?search=$query"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${apiConfig.key}:${apiConfig.secret}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Product> products = jsonList.map((e) => Product.fromJson(e)).toList();
      return products;
    } else {
      throw Exception('Failed to search products');
    }
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<Product> products = [];

  Future<void> searchProducts(String query) async {
    try {
      List<Product> searchedProducts = await API.searchProducts(query);
      setState(() {
        products = searchedProducts;
      });
    } catch (e) {
      print('Error: $e');
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
                      onTap: () {}
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductPage(
                      //       product: products,
                      //     ),
                      //   ),
                      // );},
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: onSearch,
        ),
      ),
    );
  }
}
