import 'package:abhyukthafoods/models/address.dart';

OrderModel tempOrderModel = OrderModel();

class OrderModel {
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  List<LineItems>? lineItems;
  int? orderId;
  String? orderNumber;
  String? status;
  DateTime? orderDate;
  Billing? billing;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.billing,
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

    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
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
