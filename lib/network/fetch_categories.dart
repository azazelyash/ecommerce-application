import 'dart:convert';
import 'dart:io';
import 'package:abhyukthafoods/api_config.dart';
import 'package:dio/dio.dart';
import '../models/categories.dart';

Future<List<ProductCategory>> fetchCategories() async {
  var url = '${APIConfig.url}products/categories';

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

  var categoriesData = response.data;
  List<ProductCategory> categories = [];
  categoriesData.forEach((category) {
    categories.add(ProductCategory.fromJson(category));
  });

  return categories;
}
