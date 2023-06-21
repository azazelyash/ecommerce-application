import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:abhyukthafoods/api_config.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/coupon.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/firebase_address.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/models/order_model.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<LoginResponseModel> loginCustomer(String username, String password) async {
    LoginResponseModel model = LoginResponseModel();
    CustomerModel customerModel = CustomerModel();
    FirebaseAuth auth = FirebaseAuth.instance;
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
        UserCredential user = await auth.signInWithEmailAndPassword(email: username, password: password);

        log("User ID: ${user.user!.uid}");

        // log(response.data.toString());
        model = LoginResponseModel.fromJson(response.data);
        customerModel = await APIService().getCustomerDetails(model.data!.id.toString());
        billing = await APIService().fetchAddressDetails(model.data!.id.toString());
        // log("Billing Address at API SERVICE : ${billing.toJson().toString()}");
        // log("Avatar Url at API SERVICE : ${customerModel.avatarUrl}");
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model, user.user!);
          await SharedService.setCustomerDetails(customerModel);
          // await SharedService.setAddressDetails(billing);
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

    FirebaseAuth auth = FirebaseAuth.instance;

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
        await auth.createUserWithEmailAndPassword(email: model.email!, password: model.password!);
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

  Future<Billing> fetchSpecificFirebaseAddress(String docId) async {
    Billing billing = Billing();

    try {
      var response = await firestore.collection(auth.currentUser!.uid).doc(docId).get();
      // log(response.docs[0].data().toString());
      if (response.data()!.isNotEmpty) {
        billing = Billing.fromJson(response.data()!);
      }
    } catch (e) {
      log("error = $e");
    }
    return billing;
  }

  Future<List<FirebaseAddress>> fetchFirebaseAddress() async {
    List<FirebaseAddress> billing = [];

    try {
      var response = await firestore.collection(auth.currentUser!.uid).get();
      log(response.docs[0].data().toString());
      if (response.docs.isNotEmpty) {
        billing = response.docs.map((e) => FirebaseAddress.fromJson(e.data(), e.id)).toList();
      }
    } catch (e) {
      log("error = $e");
    }
    return billing;
  }

  Future<void> addFirebaseAddress(Billing billing) async {
    try {
      await firestore.collection(auth.currentUser!.uid).add({
        'first_name': billing.firstName,
        'last_name': billing.lastName,
        'address_1': billing.address1,
        'city': billing.city,
        'state': billing.state,
        'postcode': billing.postcode,
        'country': billing.country,
        'email': billing.email,
        'phone': billing.phone,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateFirebaseAddress(String docId, Billing billing) async {
    try {
      await firestore.collection(auth.currentUser!.uid).doc(docId).update({
        'first_name': billing.firstName,
        'last_name': billing.lastName,
        'address_1': billing.address1,
        'city': billing.city,
        'state': billing.state,
        'postcode': billing.postcode,
        'country': billing.country,
        'email': billing.email,
        'phone': billing.phone,
      });

      log("Address Updated on firebase");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteFirebaseAddress(String docId) async {
    try {
      await firestore.collection(auth.currentUser!.uid).doc(docId).delete();
    } catch (e) {
      log(e.toString());
    }
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
      // await SharedService.setAddressDetails(billing);
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
      log("<------------------Order Initialized------------------->");
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

      log("<--------------------Order Created--------------------->");
      log(response.statusCode.toString());

      if (response.statusCode == 201) {
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

  static Future<List<OrderModel>> getOrders(String id) async {
    List<OrderModel> data = [];

    try {
      String url = "${APIConfig.url}${APIConfig.orderURL}?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

      log("URL at getOrders() : $url");

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        queryParameters: {
          "customer": id,
        },
      );

      // log(response.data.toString());

      if (response.statusCode == 200) {
        // data = {response.data}.map((e) => OrderModel.fromJson(e)).toList();
        data = (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }

    return data;
  }

  static Future<dynamic> verifyEmail(String email) async {
    var res = null;

    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().get(
        APIConfig.url + APIConfig.customerURl,
        queryParameters: {
          "email": email,
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data.length == 0) {
          res = null;
        } else {
          res = response.data[0];
          // log("Response at verifyEmail() : ${response.data.toString()}");
        }
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }

    return res;
  }

  static Future<bool> updatePassword(String password, String id) async {
    bool isPasswordUpdated = false;

    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().post("${APIConfig.url}${APIConfig.customerURl}/$id",
          data: {
            "password": password,
          },
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        log("Password Updated");
        isPasswordUpdated = true;
      } else {
        log(response.statusCode.toString());
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }

    return isPasswordUpdated;
  }

  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse("${APIConfig.url}products?search=$query"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${APIConfig.key}:${APIConfig.secret}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Product> products = jsonList.map((e) => Product.fromJson(e)).toList();
      return products;
    } else {
      throw Exception('Failed to search products');
    }
  }

  static Future<dynamic> validCoupon(String couponCode) async {
    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      log("Varifying Coupon Code");

      var response = await Dio().get(
        "${APIConfig.url}coupons",
        queryParameters: {
          "code": couponCode,
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      // log("Coupon Code Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data.length == 0) {
          return null;
        }
        Coupon coupon = Coupon.fromJson(response.data[0]);
        log("Coupon Code Response: ${coupon.code.toString()}");
        log("Coupon Min Amount: ${coupon.minimumAmount.toString()}");
        return coupon;
      } else {
        log(response.statusCode.toString());
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }
  }

  static Future<List<Coupon>> listCoupons() async {
    List<Coupon> coupons = [];
    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().get(
        "${APIConfig.url}coupons",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());

        List<Coupon> coupons = (response.data as List).map((e) => Coupon.fromJson(e)).toList();

        log(coupons[1].dateExpires.toString());
        return coupons;
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }

    return coupons;
  }
}
