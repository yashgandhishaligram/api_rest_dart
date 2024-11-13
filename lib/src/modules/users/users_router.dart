import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'users_service.dart';
import '../../injection/app_injection.dart' as di;

class UsersRouter {
  UsersService usersService = di.locator.get<UsersService>();
  UsersRouter();

  Handler get router {
    final router = Router();
    router.get('/users',usersService.getAllUsersHandler);
    // router.get('/user/{id}', usersService.getUserHandler);
    return router.call;
  }


}