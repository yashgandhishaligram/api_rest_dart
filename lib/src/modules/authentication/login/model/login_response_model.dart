import 'package:api_rest_dart/src/utils/extensions.dart';
import 'package:mongo_dart/mongo_dart.dart';

class LoginResponseModel {
  LoginResponseModel({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.birthDate,
    this.image,
    this.token,
    this.role,});

  LoginResponseModel.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
    gender = json['gender'];
    email = json['email'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    image = json['image'];
    token = json['token'];
    role = json['role'];
  }

  ObjectId? id;
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  String? email;
  String? phone;
  String? birthDate;
  String? image;
  String? token;
  String? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id?.toHexString();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['age'] = age;
    map['gender'] = gender;
    map['email'] = email;
    map['phone'] = phone;
    map['birthDate'] = birthDate;
    map['image'] = image;
    map['token'] = token;
    map['role'] = role;
    return map.filterNulls();
  }
}