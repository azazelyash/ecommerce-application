import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/shipping.dart';

OrderModel tempOrderModel = OrderModel();

class OrderModel {
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  List<LineItems>? lineItems;
  List<CouponLines>? couponLines;
  int? orderId;
  String? orderNumber;
  String? status;
  DateTime? orderDate;
  Billing? billing;
  Shipping? shipping;
  List<ShippingLines>? shippingLines;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.couponLines,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.billing,
    this.shippingLines,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transaction_id'] = transactionId;
    data['shipping'] = billing!.toJson();
    data['billing'] = billing!.toJson();

    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }

    if (couponLines != null) {
      data['coupon_lines'] = couponLines!.map((v) => v.toJson()).toList();
    }

    if (shippingLines != null) {
      data['shipping_lines'] = shippingLines!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;

  LineItems({this.productId, this.quantity, this.variationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['product_id'] = productId;
    data['quantity'] = quantity;
    if (variationId != null) {
      data['variation_id'] = variationId;
    }

    return data;
  }
}

class CouponLines {
  String? code;

  CouponLines({this.code});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['code'] = code;

    return data;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? address1;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;

  Shipping({
    this.firstName,
    this.lastName,
    this.address1,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.email,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'first_name': firstName,
      'last_name': lastName,
      'address_1': address1,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
    });

    return map;
  }

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address_1'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
  }
}
