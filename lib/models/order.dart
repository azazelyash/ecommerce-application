class Order {
  int id;
  String total;
  String status;
  String dateCreated;
  String? dateCompleted;
  List<OrderItem> itemList;
  Address shippingAddress;

  Order(
      {required this.id,
      required this.total,
      required this.status,
      required this.dateCreated,
      required this.dateCompleted,
      required this.itemList,
      required this.shippingAddress});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        total: json['total'],
        status: json['status'],
        dateCreated: json['date_created'],
        dateCompleted: json['date_completed'],
        itemList: [
          ...(json['line_items'] as List).map((e) => OrderItem.fromJson(e))
        ],
        shippingAddress: Address.fromJson(json['shipping']));
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

class Address {
  String firstname;
  String lastname;
  String company;
  String addr1;
  String addr2;
  String city;
  String state;
  String postcode;
  String country;
  String? email;
  String phone;

  Address(
      {required this.firstname,
      required this.lastname,
      required this.company,
      required this.addr1,
      required this.addr2,
      required this.city,
      required this.state,
      required this.postcode,
      required this.country,
      required this.email,
      required this.phone});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstname: json['first_name'],
      lastname: json['last_name'],
      company: json['company'],
      addr1: json['address_1'],
      addr2: json['address_2'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
