import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/models/categories.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:abhyukthafoods/utils/shimmer_containers.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../product_page/product_page.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key, required this.category, required this.customerModel});
  final ProductCategory category;
  final CustomerModel customerModel;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  static const _pageSize = 6;

  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchPaginatedCategory(pageKey, widget.category.id.toString(), _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    ShimmerContainer shimmerContainer = ShimmerContainer();
    return Scaffold(
      appBar: StandardAppBar(
        title: widget.category.name,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: PagedGridView<int, Product>(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: MediaQuery.of(context).size.height / 1200,
          ),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Product>(
            // firstPageProgressIndicatorBuilder: (context) => SingleChildScrollView(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Column(
            //         children: [
            //           ShimmerContainer().offerProductShimmer(),
            //           const SizedBox(height: 16),
            //           ShimmerContainer().offerProductShimmer(),
            //         ],
            //       ),
            //       Column(
            //         children: [
            //           ShimmerContainer().offerProductShimmer(),
            //           const SizedBox(height: 16),
            //           ShimmerContainer().offerProductShimmer(),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            firstPageProgressIndicatorBuilder: (context) => const Center(
              // child: Row(
              //   children: [
              //     Column(
              //       children: [
              //         shimmerContainer.offerProductShimmer(),
              //         shimmerContainer.offerProductShimmer(),
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         shimmerContainer.offerProductShimmer(),
              //         shimmerContainer.offerProductShimmer(),
              //       ],
              //     ),
              //   ],
              // ),
              child: CircularProgressIndicator(),
            ),
            itemBuilder: (context, item, index) => ProductCard(product: item, customerModel: widget.customerModel),
          ),
        ),
      ),
    );
  }
}
