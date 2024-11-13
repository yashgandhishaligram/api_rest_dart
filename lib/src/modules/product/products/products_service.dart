import 'dart:convert';
import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../../common/model/base_entity.dart';
import '../../authentication/login/jwt_service.dart';
import 'model/product.dart';
import '../../../injection/app_injection.dart' as di;

class ProductService {
  static String usersProducts = 'product_master';
  JwtService jwtService = di.locator.get<JwtService>();
  DatabaseHelper databaseHelper;

  ProductService(this.databaseHelper);

  Future<Response> createProductHandler(Request request) async {
    try {
      String body = await request.readAsString();
      Product product = productFromJson(body);
      print("product :${product.toJson()}");
      if (product != null) {
        var productCollection = databaseHelper.db?.collection(usersProducts);
        var newUser = await productCollection?.insertOne(product.toJson());
        Product newProductModel = Product.fromJson(newUser?.document);
        return Response.ok(jsonEncode(BaseResponseEntity(
            data: newProductModel,
            success: true,
            message: "Product added successfully")));
      } else {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(
            success: false, message: "Please enter product data")));
      }
    } catch (e) {
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  Future<Response> createMultipleProductHandler(Request request) async {
    try {
      String body = await request.readAsString();
      List<Map<String, dynamic>> productList = productsFromMapJson(body);
      if (productList != null) {
        print("product : $productList)");
        var productCollection = databaseHelper.db?.collection(usersProducts);
        var bulk =
            OrderedBulk(productCollection!, writeConcern: WriteConcern(w: 1));
        bulk.insertMany(productList);
        var responseBulk = await bulk.executeDocument();
        if (responseBulk.operationSucceeded) {
          return Response.ok(jsonEncode(BaseResponseEntity(
              success: true, message: "Bulk Products added successfully")));
        } else {
          return Response.ok(jsonEncode(BaseResponseEntity(
              success: true, message: "Some error occurred")));
        }
        print("response : ${responseBulk.documents}"); // 1
      } else {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(
            success: false, message: "Please enter product data")));
      }
    } catch (e) {
      print("errror :" + e.toString());
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  Future<Response> updateMultipleProductHandler(Request request) async {
    try {
      String body = await request.readAsString();
      List<Product> productList = productsFromJson(body);
      if (productList != null) {
        print("product : ${productList.length})");
        var productCollection = databaseHelper.db?.collection(usersProducts);
        var bulk =
            OrderedBulk(productCollection!, writeConcern: WriteConcern(w: 1));
        for (var product in productList) {
          var query = { "product_code": product.productCode};
          bulk.updateOne(
            UpdateOneStatement(
                query,
                ModifierBuilder()
                    .inc('quantity', product.quantity)
                    .set('title', product.title)
                    .set('description', product.description)
                    .set('price', product.price)
                    .set('discount_percentage', product.discountPercentage)
                    .set('rating', product.rating)
                    .set('category_id', product.categoryId)
                    .set('category_name', product.categoryName)
                    .set('brand_id', product.brandId)
                    .set('brand_name', product.brandName)
                    .set('product_name', product.productName).map,
                upsert: true),
          );
        }
        var responseBulk = await bulk.executeBulk();
        print("response : $responseBulk");
        if (responseBulk.isNotEmpty) {
          return Response.ok(jsonEncode(BaseResponseEntity(
              success: true, message: "Bulk Products update successfully")));
        } else {
          return Response.ok(jsonEncode(BaseResponseEntity(
              success: true, message: "Some error occurred")));
        }
      } else {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(
            success: false, message: "Please enter product data")));
      }
    } catch (e) {
      print("error :$e");
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  Future<Response> updateProductHandler(Request request) async {
    try {
      String body = await request.readAsString();
      Product product = productFromJson(body);
      Map<String, String> queryParameters = request.url.queryParameters;
      String productId = queryParameters["id"] ?? '';
      if (product != null) {
        var productCollection = databaseHelper.db?.collection(usersProducts);
        var objectProductId =
            ObjectId.fromHexString(productId);
        var updatedProduct = await productCollection?.updateOne(
            where.id(objectProductId),
            modify
                .set('title', product.title)
                .set('description', product.description)
                .set('price', product.price)
                .set('discountPercentage', product.discountPercentage)
                .set('rating', product.rating)
                .set('category_id', product.categoryId)
                .set('category_name', product.categoryName)
                .set('brand_id', product.brandId)
                .set('brand_name', product.brandName),
            upsert: false);
        print("updatedProduct $updatedProduct");
        var result = await productCollection?.findOne(where.eq("_id", objectProductId));
        Product newProductModel = Product.fromJson(result);
        return Response.ok(jsonEncode(BaseResponseEntity(
            data: newProductModel,
            success: true,
            message: "Product updated successfully")));
      } else {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(
            success: false, message: "Please enter product data")));
      }
    } catch (e) {
      print("error :$e");
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  Future<Response> getAllProductsHandler(Request request) async {
    try {
      Map<String, String> queryParameters = request.url.queryParameters;
      List productData;
      var collection = databaseHelper.db?.collection(usersProducts);
      if (queryParameters.isNotEmpty) {
        int page = int.parse(queryParameters["page"] ?? '1');
        int productLimit = int.parse(queryParameters["limit"] ?? '10');
        String categoryId = queryParameters["category_id"] ?? '';
        String brandId = queryParameters["brand_id"] ?? '';
        String categoryName = queryParameters["category"] ?? '';
        String brandName = queryParameters["brand"] ?? '';
        print("brandName : $brandName");
        print("categoryName : $categoryName");
        var startIndex = 0;
        if (page == 1) {
          startIndex = 0;
        } else {
          startIndex = (page - 1) * productLimit;
        }
        if (categoryName.isNotEmpty && brandName.isNotEmpty) {
          productData = await collection!
              .find(where
                  .limit(productLimit)
                  .eq("category_name", categoryName)
                  .eq("brand_name", brandName))
              .skip(startIndex)
              .toList();
        } else if (categoryName.isNotEmpty) {
          productData = await collection!
              .find(where
                  .limit(productLimit)
                  .eq("category_name", categoryName)
                  .skip(startIndex))
              .toList();
        } else if (brandName.isNotEmpty) {
          productData = await collection!
              .find(where
                  .limit(productLimit)
                  .eq("brand_name", brandName)
                  .skip(startIndex))
              .toList();
        } else {
          productData = await collection!
              .find(where.limit(productLimit).skip(startIndex))
              .toList();
        }
      } else {
        productData = await collection!.find().toList();
      }
      var newProductList =
          productData.map((element) => Product.fromJson(element)).toList();
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

  Future<Response> removeProductHandler(Request request) async {
    try {
      Map<String, String> queryParameters = request.url.queryParameters;
      String productId = queryParameters["id"] ?? '';
      if (productId.isNotEmpty) {
        var productCollection = databaseHelper.db?.collection(usersProducts);
        var objectProductId = ObjectId.parse(productId);
        print("objectProductId : $objectProductId");
        await productCollection?.deleteOne(where.eq('_id', objectProductId));
        return Response.ok(jsonEncode(BaseResponseEntity(
            success: true, message: "Product deleted successfully")));
      } else {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(
            success: false, message: "Please enter product id")));
      }
    } catch (e) {
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }
}
