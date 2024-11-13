import 'dart:convert';

import 'package:api_rest_dart/src/utils/extensions.dart';
import 'package:mongo_dart/mongo_dart.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

List<Map<String,dynamic>> productsFromMapJson(String str) =>
    List<Map<String,dynamic>>.from(json.decode(str).map((x) => x));


String productsToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.title,
    this.description,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.price,
    this.discountPercentage,
    this.rating,
    this.productCode,
    this.productName,
    /*   this.stock,
      this.brand,
      this.sku,
      this.weight,
      this.warrantyInformation,
      this.shippingInformation,
      this.availabilityStatus,
      this.returnPolicy,
      this.minimumOrderQuantity,
      this.images,
      this.thumbnail,*/
  });

  ObjectId? id;
  String? title;
  String? description;
  String? categoryId;
  String? categoryName;
  String? brandId;
  String? brandName;
  dynamic price;
  dynamic discountPercentage;
  dynamic rating;
  String? productCode;
  String? productName;
  int? quantity;


/*  int? stock;
  String? brand;
  String? sku;
  dynamic weight;
  String? warrantyInformation;
  String? shippingInformation;
  String? availabilityStatus;
  String? returnPolicy;
  int? minimumOrderQuantity;
  List<String>? images;
  String? thumbnail;*/

  Product.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    price = json['price'];
    discountPercentage = json['discount_percentage'];
    rating = json['rating'];
    productCode = json['product_code'];
    productName = json['product_name'];
    quantity = json['quantity'];
/*    stock = json['stock'];
    brand = json['brand'];
    sku = json['sku'];
    weight = json['weight'];
    warrantyInformation = json['warrantyInformation'];
    shippingInformation = json['shippingInformation'];
    availabilityStatus = json['availabilityStatus'];
    returnPolicy = json['returnPolicy'];
    minimumOrderQuantity = json['minimumOrderQuantity'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    thumbnail = json['thumbnail'];*/
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id?.toHexString();
    map['title'] = title;
    map['description'] = description;
    map['category_id'] = categoryId;
    map['category_name'] = categoryName;
    map['brand_id'] = brandId;
    map['brand_name'] = brandName;
    map['price'] = price;
    map['discount_percentage'] = discountPercentage;
    map['rating'] = rating;
    map['product_code'] = productCode;
    map['product_name'] = productName;
    map['quantity'] = quantity;
/*    map['stock'] = stock;
    map['brand'] = brand;
    map['sku'] = sku;
    map['weight'] = weight;
    map['warrantyInformation'] = warrantyInformation;
    map['shippingInformation'] = shippingInformation;
    map['availabilityStatus'] = availabilityStatus;
    map['returnPolicy'] = returnPolicy;
    map['minimumOrderQuantity'] = minimumOrderQuantity;
    map['images'] = images;
    map['thumbnail'] = thumbnail;*/
    return map.filterNulls();
  }
}
