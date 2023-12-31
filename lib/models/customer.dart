class CustomerModel {
  int? id;
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  String? avatarUrl;

  CustomerModel({
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'id': id,
      'email': email,
      'first_name': firstname,
      'last_name': lastname,
      'password': password,
      'username': email,
      'avatar_url': avatarUrl,
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
  }
}
