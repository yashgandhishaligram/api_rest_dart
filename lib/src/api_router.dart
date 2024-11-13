import 'package:api_rest_dart/src/modules/authentication/login/login_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'common/middleware/json_content_type_response.dart';
import 'modules/product/products/products_router.dart';
import 'modules/users/users_router.dart';

class ApiRouter {
  final UsersRouter userRouter;
  final ProductsRouter productsRouter;
  final LoginRouter loginRouter;
  ApiRouter(this.userRouter,this.productsRouter,this.loginRouter);

  Handler get router {
    final router = Router();
    final prefix = '/api';
    router.mount(prefix,loginRouter.router);
    router.mount(prefix,userRouter.router);
    router.mount(prefix,productsRouter.router);


    return Pipeline()
        .addMiddleware(corsHeaders())
        .addMiddleware(jsonContentTypeResponse())
        .addHandler(router.call);
  }
}