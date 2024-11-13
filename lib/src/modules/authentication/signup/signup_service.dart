import 'dart:convert';
import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:api_rest_dart/src/modules/authentication/signup/model/signup_request_model.dart';
import 'package:shelf/shelf.dart';
import '../../../common/model/base_entity.dart';
import 'model/signup_response_model.dart';

class SignupService {
  static String userTable = 'users_master';
  DatabaseHelper databaseHelper;
  SignupService(this.databaseHelper);

  Future<Response> getSignupHandler(Request request) async {
    try {
      String body = await request.readAsString();
      SignupRequestModel signupUser = signupRequestModelFromJson(body);
      if(signupUser != null) {
        var userCollection = databaseHelper.db?.collection(userTable);
        var findUser = await userCollection?.findOne({'phone': signupUser.phone});
        if (findUser == null) {
          var newUser = await userCollection?.insertOne(signupUser.toJson());
          SignupResponseModel newUserModel = SignupResponseModel.fromJson(newUser?.document);
          return Response.ok(jsonEncode(BaseResponseEntity(
              data: newUserModel,
              success: true,
              message: "Signup successfully. Please login")));
        } else {
          return Response.unauthorized(jsonEncode(BaseResponseEntity(
              success: false,
              message: "User already exists with given credentials.")));
        }
      } else {
        return Response.badRequest(body:jsonEncode(BaseResponseEntity(
            success: false,
            message: "Please enter valid credentials.")));
      }
    }catch(e) {
      return Response.badRequest(body:jsonEncode(BaseResponseEntity(
          success: false,
          message: "Bad Request")));
    }
  }

}