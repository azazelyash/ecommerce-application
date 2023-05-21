class Order {
  int id;
  String total;
  String status;
  String dateCreated;
  String? dateCompleted;
  List<OrderItem> itemList;

  Order(
      {required this.id,
      required this.total,
      required this.status,
      required this.dateCreated,
      required this.dateCompleted,
      required this.itemList});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        total: json['total'],
        status: json['status'],
        dateCreated: json['date_created'],
        dateCompleted: json['date_completed'],
        itemList: [
          ...(json['line_items'] as List<Map<String, dynamic>>)
              .map((e) => OrderItem.fromJson(e))
        ]);
  }
}

class OrderItem {
  int id;
  String name;
  int productId;
  int quantity;
  String total;

  OrderItem(
      {required this.id,
      required this.name,
      required this.productId,
      required this.quantity,
      required this.total});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      productId: json['product_id'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}
