class CustomerModel {
  int? id;
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  String? avatarUrl;
  Billing? billing;

  CustomerModel({
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.avatarUrl,
    this.billing,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'email': email,
      'first_name': firstname,
      'last_name': lastname,
      'password': password,
      'username': email,
      'avatar_url': avatarUrl,
      'billing': billing,
    });

    return map;
  }

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstname = json['first_name'];
    lastname = json['last_name'];
    password = json['password'];
    avatarUrl = json['avatar_url'];
    billing = json['billing'].length > 0 ? Billing.fromJson(json['billing']) : null;
  }
}

class Billing {
  String? firstName;
  String? lastName;
  String? address1;
  String? city;
  String? state;
  String? postcode;
  String? country;

  Billing({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
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
    });

    return map;
  }

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address_1'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
  }
}
