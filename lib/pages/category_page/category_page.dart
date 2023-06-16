import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/models/categories.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
      log(newItems.length.toString());
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            newPageProgressIndicatorBuilder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            itemBuilder: (context, item, index) {
              return ProductCard(
                product: item,
                customerModel: widget.customerModel,
              );
            },
          ),
        ),
      ),
    );
  }
}
