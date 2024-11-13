import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../../common/middleware/auth.dart';
import 'categories_service.dart';
import '../../../injection/app_injection.dart' as di;

class CategoriesRouter {
  ProductService productService = di.locator.get<ProductService>();
  AuthProvider authProvider = AuthProvider();
  CategoriesRouter();

  Handler get router {
    final router = Router();
    router.get('/products', productService.getAllProductsHandler);
    router.get('/products/<id>', productService.getProductHandler);
    var pipeline = Pipeline().addMiddleware(authProvider.requireAuth());
    return pipeline.addHandler(router.call);
  }
}
