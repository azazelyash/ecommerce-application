import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/models/order_model.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel> loginCustomer(String username, String password) async {
    LoginResponseModel model = LoginResponseModel();
    CustomerModel customerModel = CustomerModel();
    Billing billing = Billing();

    try {
      var response = await Dio().post(
        APIConfig.tokenUrl,
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        model = LoginResponseModel.fromJson(response.data);
        customerModel = await APIService().getCustomerDetails(model.data!.id.toString());
        billing = await APIService().fetchAddressDetails(model.data!.id.toString());
        log("Billing Address at API SERVICE : ${billing.toJson().toString()}");
        log("Avatar Url at API SERVICE : ${customerModel.avatarUrl}");
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model);
          await SharedService.setCustomerDetails(customerModel);
          await SharedService.setAddressDetails(billing);
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

  Future<Billing> fetchAddressDetails(String id) async {
    Billing billing = Billing();

    String url = "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

    try {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      billing = Billing.fromJson(data['billing']);
      // log(billing.toJson().toString());
    } catch (e) {
      log(e.toString());
    }

    return billing;
  }

  static Future<Billing> updateAddress(Billing billing, String id) async {
    String url = "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";
    log(url);
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic your_api_key',
        },
        body: jsonEncode({
          'billing': billing.toJson(),
          'shipping': {
            'first_name': billing.firstName,
            'last_name': billing.lastName,
            'address_1': billing.address1,
            'city': billing.city,
            'state': billing.state,
            'postcode': billing.postcode,
            'country': billing.country,
          },
        }),
      );

      var data = jsonDecode(response.body);

      billing = Billing.fromJson(data['billing']);
      log(billing.toJson().toString());
      await SharedService.setAddressDetails(billing);
    } catch (e) {
      log(e.toString());
    }

    return billing;
  }

  static Future<bool> createOrder(OrderModel model) async {
    bool isOrderCreated = false;

    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().post(
        APIConfig.url + APIConfig.orderURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        log(e.response!.data.toString());
      }
      log(e.message.toString());
      log(e.response.toString());
    }
    return isOrderCreated;
  }
}
