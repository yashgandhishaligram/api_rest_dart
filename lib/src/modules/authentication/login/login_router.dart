
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'login_service.dart';
import '../../../injection/app_injection.dart' as di;

class LoginRouter {
  LoginService loginService = di.locator.get<LoginService>();
  LoginRouter();

  Handler get router {
    final router = Router();
    router.post('/login', loginService.getLoginHandler);
    return router.call;
  }
}
