import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  final String issuer = '';
  //late JWT signer = '';

  JwtService(/*{required this.issuer, required String secretKey}*/) {
    // signer = JWT(secretKey);
  }

  String getGenerateToken(String userId) {
    /* Sign */
    // Create a json web token
    final jwt = JWT(
      {
        'id': userId,
        'server': {
          'id': '3e4fc296',
          'loc': 'euw-2',
        },
        "dateTime": DateTime.now().microsecondsSinceEpoch
      },
    );

    // Sign it
    return jwt.sign(SecretKey('user_token'),expiresIn: Duration(hours: 2));
  }

  JWT? validateToken(String token) {
    print('Signed token: $token\n');
    //return token;

    /* Verify */
    try {
      // Verify a token
      return JWT.verify(token, SecretKey('user_token'));
    } on JWTExpiredException {
      print('jwt expired');
    } on JWTException catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }
}
