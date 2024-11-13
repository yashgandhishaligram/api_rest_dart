import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../common/model/base_entity.dart';
import '../../database/database_helper.dart';
import 'model/user.dart';

class UsersService {
  static String usersTable = 'users_master';
  DatabaseHelper dataBaseHelper;
  UsersService(this.dataBaseHelper);

  Future<Response> getAllUsersHandler(Request request) async {
    try {
      // String body = await request.readAsString();
      var collection = dataBaseHelper.db?.collection(usersTable);
      var userData = await collection!.find().toList();
      var newProductList = userData.map((element) => UserModel.fromJson(element)).toList();
      return Response.ok(jsonEncode(BaseResponseEntity(data: newProductList, success: true, message: "Data Fetched Successfully")));
    } catch(e){
      print("error :$e");
      return Response.badRequest();
    }
  }

  // Future<Response> getUserHandler(Request request) async {
  //   final requestBody = await request.readAsString();
  //   final requestData = json.decode(requestBody);
  //
  //   final userData = requestData['user'];
  //
  //   if (userData == null) {
  //     return Response(422,
  //         body: jsonEncode(BaseResponseEntity<List<UserModel>>(data: null, success: false, message: "")));
  //   }
  //
  //   final username = userData['username'];
  //   final email = userData['email'];
  //   final password = userData['password'];
  //
  //   if (username == null) {
  //     return Response(422,
  //         body: jsonEncode(ErrorDto(errors: ['username is required'])));
  //   }
  //
  //   if (email == null) {
  //     return Response(422,
  //         body: jsonEncode(ErrorDto(errors: ['email is required'])));
  //   }
  //
  //   if (password == null) {
  //     return Response(422,
  //         body: jsonEncode(ErrorDto(errors: ['password is required'])));
  //   }
  //
  //   // try {
  //   //   user = await usersService.createUser(
  //   //       username: username, email: email, password: password);
  //   // } on ArgumentException catch (e) {
  //   //   return Response(422, body: jsonEncode(ErrorDto(errors: [e.message])));
  //   // } on AlreadyExistsException catch (e) {
  //   //   return Response(409, body: jsonEncode(ErrorDto(errors: [e.message])));
  //   // }
  //   //
  //   // final token = jwtService.getToken(user.email);
  //   //
  //   // final userDto =
  //   // UserDto(username: user.username, email: user.email, token: token);
  //
  //   return Response(201, body: jsonEncode({}));
  // }

  Future<UserModel> findUserData(UserModel user) async {
    var userCollection = dataBaseHelper.db?.collection(usersTable);
    var findUser = await userCollection?.findOne({'phone': user.phone});
    UserModel newUserModel = UserModel.fromJson(findUser);
    return newUserModel;
  }


}