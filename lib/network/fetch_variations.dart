import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/network/network_helper.dart';
import 'package:dio/dio.dart';

import '../models/variations.dart';

Future<List<Variation>> fetchVariations(String productId) async {
  var url = '${APIConfig.url}products/$productId/variations';

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
  // log(productsData.toString());

  List<Variation> variations = [];
  response.data.forEach((data) {
    variations.add(Variation.fromJson(data));
    // log(data.toString());
  });

  // for (var x in variations) {
  //   log(x.name.toString())
  //   log(x.images[0);
  // }
  return variations;
}
