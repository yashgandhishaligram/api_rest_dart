import 'dart:convert';
import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:api_rest_dart/src/modules/authentication/login/jwt_service.dart';
import 'package:api_rest_dart/src/modules/authentication/login/model/login_request_model.dart';
import 'package:api_rest_dart/src/modules/authentication/login/model/login_response_model.dart';
import 'package:shelf/shelf.dart';
import '../../../common/model/base_entity.dart';
import '../../../injection/app_injection.dart' as di;

class LoginService {
  static String userTable = 'users_master';
  JwtService jwtService = di.locator.get<JwtService>();
  DatabaseHelper databaseHelper;
  LoginService(this.databaseHelper);

  Future<Response> getLoginHandler(Request request) async {
    try {
      String body = await request.readAsString();
      LoginRequestModel loginRequestModel = loginRequestModelFromJson(body);
      if (loginRequestModel != null) {
        var userCollection = databaseHelper.db?.collection(userTable);
        var findUser =
            await userCollection?.findOne({'phone': loginRequestModel.phone});
        if (findUser != null) {
          if (findUser['password'] == loginRequestModel.password) {
            var token = jwtService.getGenerateToken(findUser['_id'].toString());
            LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(findUser);
            loginResponseModel.token = token;
            return Response.ok(jsonEncode(BaseResponseEntity(
                data: loginResponseModel,
                success: true,
                message: "User logged in successfully.")));
          } else {
            return Response.unauthorized(jsonEncode(BaseResponseEntity(
                success: false, message: "Please enter correct password.")));
          }
        } else {
          return Response.unauthorized(jsonEncode(BaseResponseEntity(
              success: false,
              message: "User doesn't exists with credentials. Please signup")));
        }
      } else {
        return Response.badRequest(
            body: jsonEncode(BaseResponseEntity(
                success: false, message: "Please enter valid credentials.")));
      }
    } catch (e) {
      print("error :$e");
      return Response.badRequest(
          body: jsonEncode(
              BaseResponseEntity(success: false, message: "Bad Request")));
    }
  }

  // String hashPassword(String password) {
  //   final bytes = utf8.encode(password);
  //   return sha256.convert(bytes).toString();
  // }

// var collection = databaseHelper.db?.collection('product_master');
// var productData = await collection!.find().toList();
// var productList = await productData.first['products'];
// var newProductList = productList.map((element) => Product.fromJson(element)).toList();
}
