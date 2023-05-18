import 'dart:convert';
import 'dart:developer';

LoginResponseModel loginResponseModel(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  bool? success;
  int? statusCode;
  String? code;
  String? message;
  Data? data;

  LoginResponseModel({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'].length > 0 ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }

    return data;
  }
}

class Data {
  String? token;
  int? id;
  String? email;
  String? nicename;
  String? firstName;
  String? lastName;
  String? displayName;
  String? avatarUrl;

  Data({
    this.token,
    this.id,
    this.email,
    this.nicename,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatarUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    nicename = json['nicename'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['token'] = token;
    data['id'] = id;
    data['email'] = email;
    data['nicename'] = nicename;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['displayName'] = displayName;

    return data;
  }
}
