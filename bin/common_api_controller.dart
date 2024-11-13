import 'dart:async';
import 'dart:convert';

import 'package:api_rest_dart/src/common/model/base_entity.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class CommonApiController {
  Db db;
  CommonApiController(this.db);
  var headers = {'Content-Type': 'application/json'};
  Handler get handler {
    final router = Router()
      ..get('/', _rootHandler)
      ..get('/products', _productsHandler)
      ..post('/get_product', _getProductHandler);
    var handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return handler;
  }

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Future<Response> _productsHandler(Request request) async {
    try {
     // String body = await request.readAsString();
      var collection = db.collection('product_master');
      List productData = await collection.find().toList();
      var productList = await productData.first['products'];
      return Response.ok(jsonEncode(BaseResponseEntity(data: productList, success: true, message: "Data Fetched Successfully")), headers: headers);
    } catch(e){
      print("error :$e");
      return Response.badRequest();
  }
}

  Future<Response> _getProductHandler(Request request) async {
    String body = await request.readAsString();
    // Product product = productFromJson(body);
    var collection = db.collection('product_master');
    List productData = await collection.find().toList();
    List productList = productData.first['products'];
    // print("body :" + body);
    // var product = productList.firstWhere((element) => element['id'] == body['id']);
    return Response.ok(jsonEncode(BaseResponseEntity(data: productList, success: true, message: "Data Fetched Successfully")));
  }

}
