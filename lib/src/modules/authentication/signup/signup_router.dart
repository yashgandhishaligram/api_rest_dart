
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'signup_service.dart';
import '../../../injection/app_injection.dart' as di;

class SignupRouter {
  SignupService signupService = di.locator.get<SignupService>();
  SignupRouter();

  Handler get router {
    final router = Router();
    router.post('/signup', signupService.getSignupHandler);
    return router.call;
  }
}
