import 'dart:async';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/pages/product_page/product_page.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.customerModel}) : super(key: key);
  @override
  CustomerModel customerModel;
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchProducts(searchController.text);
    });
  }

  List<Product> products = [];
  bool isLoading = false;
  Future<void> _searchProducts(String query) async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Product> searchedProducts = await APIService.searchProducts(query);

      setState(() {
        products = searchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SearchTextfield(
                controller: searchController,
                onSearch: _searchProducts,
              ),
              const SizedBox(height: 20),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : products.isEmpty
                      ? const Center(
                          child: Text('No results'),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductPage(
                                              product: product,
                                              customerModel: widget.customerModel,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        product.name.toString(),
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width,
                                  //   height: 1,
                                  //   color: Colors.black.withOpacity(0.1),
                                  // ),
                                ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,

          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // onSubmitted: onSearch,
        ),
      ),
    );
  }
}
