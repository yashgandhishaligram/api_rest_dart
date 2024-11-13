import 'dart:convert';

SignupRequestModel signupRequestModelFromJson(String str) =>
    SignupRequestModel.fromJson(json.decode(str));

String signupRequestModelToJson(SignupRequestModel data) =>
    json.encode(data.toJson());

class SignupRequestModel {
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  String? email;
  String? phone;
  String? username;
  String? birthDate;
  String? image;
  String? password;
  String? role;

  SignupRequestModel({
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.birthDate,
    this.image,
    this.password,
    this.role
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      SignupRequestModel(
          firstName: json['firstName'],
          lastName: json['lastName'],
          age: json['age'],
          gender: json['gender'],
          email: json['email'],
          phone: json['phone'],
          birthDate: json['birthDate'],
          image: json['image'],
          password: json['password'],
          role: json['role']);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['age'] = age;
    map['gender'] = gender;
    map['email'] = email;
    map['phone'] = phone;
    map['birthDate'] = birthDate;
    map['image'] = image;
    map['password'] = password;
    map['role'] = role;
    return map;
  }
}
