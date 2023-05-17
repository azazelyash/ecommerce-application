
import 'package:abhyukthafoods/network/network_helper.dart';
import 'package:abhyukthafoods/utils/api_key.dart';

import '../models/categories.dart';

Future<List<ProductCategory>> fetchCategories() async {
  var url =
      '${storeUrl}products/categories?consumer_key=$consumerKey&consumer_secret=$consumerSecret';

  NetworkHelper networkHelper = NetworkHelper(url);

  var categoriesData = await networkHelper.getData();
  // log(categoriesData.toString());

  List<ProductCategory> categories = [];
  categoriesData.forEach((category) {
    categories.add(ProductCategory.fromJson(category));
  });

  // for (var x in categories) {
  //   log(x.image['src'].toString());
  // }
  return categories;
}
