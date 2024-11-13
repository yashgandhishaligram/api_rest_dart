import 'dart:convert';

import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../../common/model/base_entity.dart';
import '../../authentication/login/jwt_service.dart';
import 'model/category.dart';
import '../../../injection/app_injection.dart' as di;

class ProductService {
  static String usersProducts = 'product_master';
  JwtService jwtService = di.locator.get<JwtService>();
  DatabaseHelper databaseHelper;

  ProductService(this.databaseHelper);

  Future<Response> getAllProductsHandler(Request request) async {
    try {
      Map<String, String> queryParameters = request.url.queryParameters;
      List productData;
      var collection = databaseHelper.db?.collection(usersProducts);
      if (queryParameters.isNotEmpty) {
        int page = int.parse(queryParameters["page"] ?? '1');
        int productLimit = int.parse(queryParameters["limit"] ?? '10');
        var startIndex = 0;
        if (page == 1) {
          startIndex = 0;
        } else {
          startIndex = (page - 1) * productLimit;
        }
        productData = await collection!.find(where.limit(productLimit).skip(startIndex)).toList();
      } else {
        productData = await collection!.find().toList();
      }
      var newProductList = productData.map((element) => Product.fromJson(element)).toList();
      var list = newProductList.map((element)=> element.brand).toList();
      print("newCategory list : ${list.toSet()}");
      if (newProductList.isNotEmpty) {
        return Response.ok(jsonEncode(BaseResponseEntity(
            data: newProductList,
            success: true,
            message: "Data Fetched Successfully")));
      } else {
        return Response.ok(jsonEncode(BaseResponseEntity(
            data: newProductList,
            success: true,
            message: "No products available")));
      }
    } catch (e) {
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  Future<Response> getProductHandler(Request request) async {
    try {
      String productId = request.url.pathSegments.last;
      //dynamic data = request.context['data'];
      //String? userId = data['id'];
      var collection = databaseHelper.db?.collection(usersProducts);
      var productData =
          await collection?.findOne(where.eq("id", int.parse(productId)));
      if (productData != null) {
        Product product = Product.fromJson(productData);
        return Response.ok(jsonEncode(BaseResponseEntity(
            data: product,
            success: true,
            message: "Product fetched successfully")));
      } else {
        return Response.ok(jsonEncode(BaseResponseEntity(
            success: true, message: "Product not available with given id.")));
      }
    } catch (e) {
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }
}
