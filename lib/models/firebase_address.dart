import 'dart:developer';

import 'package:abhyukthafoods/models/address.dart';

class FirebaseAddress {
  String? id;
  Billing? billing;

  FirebaseAddress({
    this.id,
    this.billing,
  });

  // FirebaseAddress.fromJSon(Map<String, dynamic> json, String docId)
  //     : id = docId,
  //       billing = Billing.fromJson(json);

  FirebaseAddress.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    billing = Billing.fromJson(json);
  }
}
