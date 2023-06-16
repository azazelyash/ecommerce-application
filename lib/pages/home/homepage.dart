import 'dart:async';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/comps/category_listview.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/network/fetch_categories.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:abhyukthafoods/utils/shimmer_containers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomerModel? model;

  @override
  void initState() {
    super.initState();
    model = widget.customerModel;
  }

  @override
  Widget build(BuildContext context) {
    ShimmerContainer shimmerContainer = ShimmerContainer();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: HomeAppBar(customerModel: model),
        body: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),

            /* ----------------------------- Slidding Banner ---------------------------- */

            const HeroSection(),
            const SizedBox(
              height: 10,
            ),
            const Row(
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

            /* --------------------------- Categories Section --------------------------- */

            CategoriesSection(shimmerContainer: shimmerContainer, model: model),
            const SizedBox(
              height: 10,
            ),
            const Row(
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
                  return shimmerContainer.offerProductShimmer();
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
                        childAspectRatio: MediaQuery.of(context).size.height / 1350,
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

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.shimmerContainer,
    required this.model,
  });

  final ShimmerContainer shimmerContainer;
  final CustomerModel? model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FutureBuilder(
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
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => HeroSectionState();
}

class HeroSectionState extends State<HeroSection> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  int currentPage = 0;
  Timer? timer;

  final List<Widget> pages = [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: const Image(
        image: AssetImage('assets/Banners/Nonveg new.png'),
        fit: BoxFit.cover,
        height: double.infinity,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: const Image(
        image: AssetImage('assets/Banners/spcies and powders.png'),
        fit: BoxFit.cover,
        height: double.infinity,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: const Image(
        image: AssetImage('assets/Banners/Sweetsnew.png'),
        fit: BoxFit.cover,
        height: double.infinity,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: const Image(
        image: AssetImage('assets/Banners/veg pcikels.png'),
        fit: BoxFit.cover,
        height: double.infinity,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  @override
  void dispose() {
    stopAutoScroll();
    controller.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < pages.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void stopAutoScroll() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext newContext) {
    return Column(
      children: [
        SizedBox(
          height: 142,
          // width: MediaQuery.of(newContext).size.width * 0.9,
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
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            spacing: 4,
            expansionFactor: 2,
            activeDotColor: kPrimaryColor,
            dotColor: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
