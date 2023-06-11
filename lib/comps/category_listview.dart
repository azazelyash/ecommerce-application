import 'dart:developer' as out;
import 'dart:math';
import 'package:abhyukthafoods/models/categories.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/category_page/category_page.dart';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.categories, required this.customerModel});
  final categories;
  final CustomerModel customerModel;
  Color generateRandomLightColor() {
    final random = Random();
    final r = 200 + random.nextInt(56); // random value between 200-255
    final g = 200 + random.nextInt(56);
    final b = 200 + random.nextInt(56);
    return Color.fromRGBO(r, g, b, 1.0);
  }

  String renameCategory(String text) {
    HtmlUnescape unescape = HtmlUnescape();
    String data = unescape.convert(text);
    return data;
  }

  Widget category(BuildContext context, int index, List<ProductCategory> categories) {
    out.log(categories[index].name);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(category: categories[index], customerModel: customerModel),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: generateRandomLightColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(7),
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: categories[index].image != null
                  ? Image(fit: BoxFit.cover, image: NetworkImage(categories[index].image['src'])

                      // NetworkImage(snapshot.data[index].image['src']),
                      )
                  : Placeholder(),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 100,
            child: Text(
              // snapshot.data[index].name,
              renameCategory(categories[index].name),
              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 100,
        width: double.infinity,
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          physics: const PageScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return category(context, index, categories);
          },
        ));
  }
}
