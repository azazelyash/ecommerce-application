import 'dart:convert';
import 'dart:developer';

import 'package:abhyukthafoods/network/network_helper.dart';
import 'package:abhyukthafoods/utils/api_key.dart';
import 'package:http/http.dart' as http;

import '../models/products.dart';

Future<List<Product>> fetchProducts() async {
  var url =
      '${storeUrl}products?consumer_key=$consumerKey&consumer_secret=$consumerSecret';

  NetworkHelper networkHelper = NetworkHelper(url);

  var productsData = await networkHelper.getData();
  // log(productsData.toString());

  List<Product> products = [];
  productsData.forEach((data) {
    products.add(Product.fromJson(data));
  });

  for (var x in products) {
    // log(x.name.toString());
    log(x.images[0]['src'].toString());
  }
  return products;
}

Future<List<Product>> fetchPaginatedCategory(
    int page, String categoryId, int pageSize) async {
  List<Product> products = [];
  try {
    final uri = Uri.https(
      'grocerystore.skygoaltech.com',
      '/wp-json/wc/v3/products',
      {
        'category': categoryId,
        'page': page.toString(),
        'per_page': pageSize.toString()
      },
    );
    final response = await http.get(
      uri,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );
    jsonDecode(response.body).forEach((data) {
      products.add(Product.fromJson(data));
    });
  } catch (e) {
    log(e.toString());
    rethrow; //errorbuilder handles rethrown exception
  }
  return products;
}
