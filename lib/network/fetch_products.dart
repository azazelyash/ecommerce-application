import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/utils/api_key.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/products.dart';

Future<List<Product>> fetchProducts() async {
  var url = '${APIConfig.url}products';

  var authToken = base64.encode(
    utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
  );
  final response = await Dio().get(url,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      ));

  List<Product> products = [];
  response.data.forEach((data) {
    products.add(Product.fromJson(data));
  });

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
