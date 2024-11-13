import 'dart:convert';

import 'package:api_rest_dart/src/common/model/base_entity.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../modules/authentication/login/jwt_service.dart';

class AuthProvider {
  JwtService jwtService = JwtService();
  AuthProvider();

  Middleware requireAuth() => (innerHandler) {
    return (request) async {
      final authorizationHeader = request.headers['Authorization'] ??
          request.headers['authorization'];

      if (authorizationHeader == null) {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(success: false, message: "Please enter user token.")));
      }

      final verifyToken = await getTokenAuthorizationHeader(authorizationHeader);
      if (verifyToken == null) {
        return Response.unauthorized(jsonEncode(BaseResponseEntity(success: false, message: "Please enter valid user token.")));
      }

      request = request.change(context: {'data': verifyToken.payload});

      return innerHandler(request);
    };
  };

  Middleware optionalAuth() => (innerHandler) {
    return (request) async {
      final authorizationHeader = request.headers['Authorization'] ??
          request.headers['authorization'];

      if (authorizationHeader != null) {
        final verifyToken = await getTokenAuthorizationHeader(authorizationHeader);
        if (verifyToken == null) {
          return Response(401);
        }

        request = request.change(context: {'data': verifyToken.payload});
      }

      return innerHandler(request);
    };
  };

  Future<JWT?> getTokenAuthorizationHeader(String authorizationHeader) async {
    if (!authorizationHeader.startsWith('Bearer ')) {
      return null;
    }

    final token = authorizationHeader.replaceFirst('Bearer', '').trim();
    //print("token : $token");
    if (token.isEmpty) {
      return null;
    }

   JWT? userToken =  jwtService.validateToken(token);
  //  print("userToken : $userToken");
    if (userToken == null) {
      return null;
    }

    return userToken;
  }
}