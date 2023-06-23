double shippingCharges = 0.0;
double minimumOrderForFreeDelivery = 0.0;

class ShippingLines {
  String? methodId;
  String? methodTitle;
  String? total;

  ShippingLines({
    this.methodId,
    this.methodTitle,
    this.total,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['method_id'] = methodId;
    data['method_title'] = methodTitle;
    data['total'] = total;

    return data;
  }
}
