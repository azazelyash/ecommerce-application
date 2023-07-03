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
import 'package:abhyukthafoods/pages/auth/firebase_otp_verification.dart';
import 'package:abhyukthafoods/pages/auth/login_otp_verification.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String? docID;

class APIService {
  static var client = http.Client();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<LoginResponseModel> loginCustomer(
      String username, String password, String uid) async {
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
        model = LoginResponseModel.fromJson(response.data);
        customerModel =
            await APIService().getCustomerDetails(model.data!.id.toString());
        billing =
            await APIService().fetchAddressDetails(model.data!.id.toString());
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model, uid);
          await SharedService.setCustomerDetails(customerModel);
        }
      }
    } on DioError catch (e) {
      log("Signin Error: $e");
    }

    return model;
  }

  static Future<LoginResponseModel> newLoginCustomerUsingFirebase(
      String username, String password, String uid) async {
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
        model = LoginResponseModel.fromJson(response.data);
        APIService().fetchDocumentID();
        log(model.toString());
        customerModel =
            await APIService().getCustomerDetails(model.data!.id.toString());
        // billing = await APIService().fetchAddressDetails(model.data!.id.toString());
        if (model.statusCode == 200) {
          await SharedService.setLoginDetails(model, uid);
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
    String url =
        "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

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
    FirebaseAuth auth = FirebaseAuth.instance;
    bool ret = false;

    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

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
        log("Customer Created");
      }

      // if (response.statusCode == 201) {
      //   await auth.createUserWithEmailAndPassword(email: model.email!, password: model.password!);
      //   ret = true;
      // }
    } on DioError catch (e) {
      log(e.toString());
    }

    return ret;
  }

  Future<Billing> fetchAddressDetails(String id) async {
    Billing billing = Billing();

    String url =
        "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

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

  Future<Billing> fetchSpecificFirebaseAddress(
      String specificDocuementID) async {
    Billing billing = Billing();

    try {
      log(specificDocuementID);
      var response = await firestore
          .collection(auth.currentUser!.uid)
          .doc(docID)
          .collection("address")
          .doc(specificDocuementID)
          .get();
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
      var response = await firestore
          .collection(auth.currentUser!.uid)
          .doc(docID)
          .collection("address")
          .get();
      log(response.docs[0].data().toString());
      if (response.docs.isNotEmpty) {
        billing = response.docs
            .map((e) => FirebaseAddress.fromJson(e.data(), e.id))
            .toList();
      }
    } catch (e) {
      log("error = $e");
    }
    return billing;
  }

  Future<void> updateFirebaseAddress(
      String specificDocID, Billing billing) async {
    try {
      await firestore
          .collection(auth.currentUser!.uid)
          .doc(docID)
          .collection("address")
          .doc(specificDocID)
          .update({
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
      await firestore
          .collection(auth.currentUser!.uid)
          .doc(docID)
          .collection("address")
          .doc(docId)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Billing> updateAddress(Billing billing, String id) async {
    String url =
        "${APIConfig.url}${APIConfig.customerURl}/$id?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";
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
      String url =
          "${APIConfig.url}${APIConfig.orderURL}?consumer_key=${APIConfig.key}&consumer_secret=${APIConfig.secret}";

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
        data =
            (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
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
      var response =
          await Dio().post("${APIConfig.url}${APIConfig.customerURl}/$id",
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
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${APIConfig.key}:${APIConfig.secret}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Product> products =
          jsonList.map((e) => Product.fromJson(e)).toList();
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

        List<Coupon> coupons =
            (response.data as List).map((e) => Coupon.fromJson(e)).toList();

        log(coupons[1].dateExpires.toString());
        return coupons;
      }
    } on DioError catch (e) {
      log(e.response.toString());
    }

    return coupons;
  }

  Future<double> freeShippingEligiblility() async {
    double minOrderValue = 0.0;
    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().get(
        "${APIConfig.url}shipping/zones/1/methods",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Min Order Value: ${response.data[0]["settings"]["method_free_shipping"]["value"]}");
        minOrderValue = double.parse(
            response.data[0]["settings"]["method_free_shipping"]["value"]);
      }
    } on DioError catch (e) {
      log("Shipping Error: ${e.response}");
    }

    return minOrderValue;
  }

  Future<double> shippingCharge() async {
    double shippingCharge = 0.0;
    var authToken = base64.encode(
      utf8.encode("${APIConfig.key}:${APIConfig.secret}"),
    );

    try {
      var response = await Dio().get(
        "${APIConfig.url}shipping/zones/1/methods",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Shipping Charge: ${response.data[0]["settings"]["method_rules"]["value"][0]["cost_per_order"]}");
        shippingCharge = double.parse(response.data[0]["settings"]
            ["method_rules"]["value"][0]["cost_per_order"]);
      }
    } on DioError catch (e) {
      log("Shipping Error: ${e.response}");
    }

    return shippingCharge;
  }

  Future<void> firebasePhoneAuth(
      String phoneNumber, BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        log("Phone Auth Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Phone Auth Failed: ${e.message}");
        log("Phone number does not exist");
        // Phone number doesn't exist, show a dialog box
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sign Up"),
              content: Text(
                  "Please enter a proper phone number that exist or Try again."),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      codeSent: (String verificationID, int? resendToken) async {
        log("Code Sent");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FirebaseOTPVerificationPage(
              phone: phoneNumber,
              verificationId: verificationID,
            ),
          ),
        );
        // Navigator.of(context).pop();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> firebasePhoneLogin(
      String phoneNumber, BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        log("Phone Auth Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Phone Auth Failed: ${e.message}");
        log("Phone number does not exist");
        // Phone number doesn't exist, show a dialog box
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Invalid OTP"),
              content: Text(
                  "Please enter the correct otp that sent to your number."),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      codeSent: (String verificationID, int? resendToken) async {
        log("Code Sent");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginOTPVerificationPage(
              verificationId: verificationID,
              phone: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> fetchDocumentID() async {
    try {
      var response = await firestore.collection(auth.currentUser!.uid).get();
      // log(response.docs[0].id);
      docID = response.docs[0].id;
      log("Document ID: $docID");
    } catch (e) {
      log("Error Finding Docuement Id: $e");
    }
  }

  Future<void> addFirebaseAddress(Billing billing) async {
    try {
      await firestore
          .collection(auth.currentUser!.uid)
          .doc(docID)
          .collection("address")
          .doc()
          .set({
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
      // await firestore.collection(auth.currentUser!.uid).add({
      //   'first_name': billing.firstName,
      //   'last_name': billing.lastName,
      //   'address_1': billing.address1,
      //   'city': billing.city,
      //   'state': billing.state,
      //   'postcode': billing.postcode,
      //   'country': billing.country,
      //   'email': billing.email,
      //   'phone': billing.phone,
      // });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveLoginDataToFirebase(String uid, String email,
      String password, String fname, String lname) async {
    try {
      await firestore.collection(uid).add({
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'password': password,
      });
    } catch (e) {
      log("Firebase Storing Credential Error: $e");
    }
  }

  Future<LoginResponseModel> fetchEmailPassword(String uid) async {
    LoginResponseModel loginResponseModel = LoginResponseModel();
    try {
      var response = await firestore.collection(uid).get();

      String email = response.docs[0]['email'];
      String password = response.docs[0]['password'];

      docID = response.docs[0].id.toString();
      log("Current Document ID at fetchEmail&Password: ${docID!}");

      loginResponseModel =
          await newLoginCustomerUsingFirebase(email, password, uid);
    } catch (e) {
      log("Email Fetch Error: $e");
    }
    return loginResponseModel;
  }

  isPhoneRegistered(String phone) {}
}
