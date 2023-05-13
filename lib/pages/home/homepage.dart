import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/comps/category_listview.dart';
import 'package:abhyukthafoods/utils/shimmer_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final List pages = [
    SvgPicture.asset('assets/Banners/banner 3.svg'),
    SvgPicture.asset('assets/Banners/banner 4.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    int a = 2;
    ShimmerContainer shimmerContainer = ShimmerContainer();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(title: ''),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2))
            .then((value) => a), //insert fetch here
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: [shimmerContainer.categoryShimmer()],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: 2,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: pages[index],
                      ),
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
                  const Categories(categories: [
                    'Veg Pickles',
                    'Veg Pickles',
                    'Veg Pickles',
                    'Veg Pickles',
                    'Veg Pickles'
                  ]),
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
                  Padding(
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
                            MediaQuery.of(context).size.height / 1100,
                      ),
                      itemBuilder: (BuildContext gridcontext, int index) {
                        return const ProductCard();
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
