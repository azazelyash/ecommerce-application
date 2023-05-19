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
    CustomerModel customerModel = CustomerModel();

    try {
      var response = await Dio().post(APIConfig.tokenUrl,
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
        log(response.data.toString());
        model = LoginResponseModel.fromJson(response.data);
        customerModel = await APIService().getCustomerDetails(model.data!.id.toString());
        log("Avatar Url at API SERVICE : ${customerModel.avatarUrl}");
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model);
          await SharedService.setCustomerDetails(customerModel);
        }
      }
    } on DioError catch (e) {
      log(e.toString());
    }

    return model;
  }

  Future<CustomerModel> getCustomerDetails(String id) async {
    CustomerModel model = CustomerModel();
    String url = "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

    try {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      model = CustomerModel.fromJson(data);
    } catch (e) {
      log(e.toString());
    }

    return model;
  }

  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        APIConfig.url + APIConfig.customerURl,
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
