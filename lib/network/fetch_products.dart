import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:abhyukthafoods/api_config.dart';
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

Future<List<Product>> fetchPaginatedCategory(int page, String categoryId, int pageSize) async {
  log('fetchPaginatedCategory called');
  log('page: $page, categoryId: $categoryId, pageSize: $pageSize');
  List<Product> products = [];
  try {
    var url = '${APIConfig.url}products';

    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );
    final response = await Dio().get(url,
        queryParameters: {'category': categoryId, 'page': page.toString(), 'per_page': pageSize.toString()},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ));
    response.data.forEach((data) {
      products.add(Product.fromJson(data));
    });
  } catch (e) {
    rethrow; //errorbuilder handles rethrown exception
  }
  return products;
}
