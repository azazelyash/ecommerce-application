import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel> loginCustomer(String username, String password) async {
    LoginResponseModel model = LoginResponseModel();

    try {
      var response = await Dio().post(APIConfig().tokenUrl,
          data: {
            "username": username,
            "password": password,
          },
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
            },
          ));

      if (response.statusCode == 200) {
        log("Login Success");
        // log(response.data.toString());
        model = LoginResponseModel.fromJson(response.data);
        log(model.data!.token.toString());
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model);
        }
      }
    } on DioError catch (e) {
      log(e.toString());
    }

    return model;
    // Map<String, String> requestHeaders = {
    //   'Content-type': 'application/x-www-form-urlencoded',
    // };

    // var response = await client.post(
    //   Uri.parse("${APIConfig().loginUrl}/wp-json/jwt-auth/v1/token"),
    //   headers: requestHeaders,
    //   body: {
    //     'username': username,
    //     'password': password,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   log("Login Success");
    //   var data = json.decode(response.body);
    //   LoginResponseModel model = LoginResponseModel.fromJson(data);

    // if (model.statusCode == 200) {
    //   await SharedService.setLoginDetails(model);
    // }

    //   log(model.toString());

    //   return model.statusCode == 200 ? true : false;
    // }

    // return false;
  }

  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("${APIConfig().key}:${APIConfig().secret}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        APIConfig().url + APIConfig().customerURl,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      log(e.toString());
    }

    return ret;
  }
}
