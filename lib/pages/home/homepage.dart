import 'dart:async';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/comps/category_listview.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/network/fetch_categories.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/utils/shimmer_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  CustomerModel? model;
  Timer? timer;
  int currentPage = 0;

  final List<Widget> pages = [
    SvgPicture.asset('assets/Banners/banner 3.svg'),
    SvgPicture.asset('assets/Banners/banner 4.svg'),
  ];

  @override
  void initState() {
    super.initState();
    model = widget.customerModel;
    startAutoScroll();
  }

  @override
  void dispose() {
    stopAutoScroll();
    controller.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentPage < pages.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      controller.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void stopAutoScroll() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ShimmerContainer shimmerContainer = ShimmerContainer();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(customerModel: model),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: pages[index],
                ),
                onPageChanged: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return shimmerContainer.categoryShimmer();
                } else {
                  return Categories(
                    categories: snapshot.data,
                    customerModel: model!,
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Recently viewed',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return shimmerContainer.categoryShimmer();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            MediaQuery.of(context).size.height / 1350,
                      ),
                      itemBuilder: (BuildContext gridcontext, int index) {
                        return ProductCard(
                          product: snapshot.data![index],
                          customerModel: model!,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
