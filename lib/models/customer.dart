class CustomerModel {
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  String? avatarUrl;

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

  CustomerModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstname = json['first_name'];
    lastname = json['last_name'];
    password = json['password'];
    avatarUrl = json['avatar_url'];
  }
}
