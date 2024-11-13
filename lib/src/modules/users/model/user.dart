import 'dart:convert';

import 'package:api_rest_dart/src/utils/extensions.dart';
import 'package:mongo_dart/mongo_dart.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());


class UserModel {
  UserModel({
      this.id,
      this.firstName, 
      this.lastName,
      this.age, 
      this.gender, 
      this.email, 
      this.phone,
      this.birthDate, 
      this.image,
      this.role,});

  UserModel.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
    gender = json['gender'];
    email = json['email'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    image = json['image'];
    role = json['role'];
  }
  ObjectId? id;
  String? firstName;
  String? lastName;
  String? maidenName;
  int? age;
  String? gender;
  String? email;
  String? phone;
  String? birthDate;
  String? image;
  String? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id?.toHexString();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['maidenName'] = maidenName;
    map['age'] = age;
    map['gender'] = gender;
    map['email'] = email;
    map['phone'] = phone;
    map['birthDate'] = birthDate;
    map['image'] = image;
    map['role'] = role;
    return map.filterNulls();
  }
}