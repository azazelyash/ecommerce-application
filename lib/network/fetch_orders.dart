import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/models/order.dart';
import 'dart:convert';
import 'dart:io';
import 'package:abhyukthafoods/utils/api_key.dart';
import 'package:dio/dio.dart';

Future<List<Order>> fetchOrders(String customerId) async {
  var url = '${APIConfig.url}orders';

  var authToken = base64.encode(
    utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
  );
  final response = await Dio().get(url,
      queryParameters: {'customer': customerId},
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      ));

  List<Order> products = [];
  response.data.forEach((data) {
    products.add(Order.fromJson(data));
  });

  return products;
}
