class CustomerModel {
  String email;
  String firstname;
  String lastname;
  String password;

  CustomerModel({
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'email': email,
      'first_name': firstname,
      'last_name': lastname,
      'password': password,
      'username': email,
    });

    return map;
  }
}
