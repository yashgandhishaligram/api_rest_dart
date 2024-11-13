import 'package:api_rest_dart/src/database/database_helper.dart';
import 'package:api_rest_dart/src/modules/authentication/signup/signup_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'common/middleware/json_content_type_response.dart';
import 'modules/authentication/login/login_router.dart';
import 'modules/product/products/products_router.dart';
import 'modules/users/users_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'injection/app_injection.dart' as di;

class LocalServerConfig {
  Future setServerConfig() async {
    await di.init();
    di.locator.get<DatabaseHelper>().initDb();
    var allCascadeRouter = Cascade()
        .add(LoginRouter().router)
        .add(SignupRouter().router)
        .add(UsersRouter().router)
        .add(ProductsRouter().router)
        .handler;
    final router = Router();
    final prefix = '/api';
    router.mount(prefix,allCascadeRouter);
    var handler = Pipeline()
        .addMiddleware(corsHeaders())
        .addMiddleware(jsonContentTypeResponse())
        .addHandler(router.call);
    final server = await shelf_io.serve(handler, '127.0.0.1', 8080);
    print('Server listening on port ${server.port}');
  }
}
