
import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:api_rest_dart/src/modules/authentication/login/jwt_service.dart';
import 'package:api_rest_dart/src/modules/authentication/login/login_service.dart';
import 'package:api_rest_dart/src/modules/authentication/signup/signup_service.dart';
import 'package:get_it/get_it.dart';
import '../modules/product/products/products_service.dart';
import '../modules/users/users_service.dart';

final locator = GetIt.instance;

Future<void> init() async {
  locator.registerSingleton<DatabaseHelper>(DatabaseHelper());
  locator.registerSingleton<JwtService>(JwtService());
  locator.registerSingleton<UsersService>(UsersService(locator.get<DatabaseHelper>()));
  locator.registerSingleton<LoginService>(LoginService(locator.get<DatabaseHelper>()));
  locator.registerSingleton<ProductService>(ProductService(locator.get<DatabaseHelper>()));
  locator.registerSingleton<SignupService>(SignupService(locator.get<DatabaseHelper>()));
}