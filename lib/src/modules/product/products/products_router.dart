import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../../common/middleware/auth.dart';
import 'products_service.dart';
import '../../../injection/app_injection.dart' as di;

class ProductsRouter {
  ProductService productService = di.locator.get<ProductService>();
  AuthProvider authProvider = AuthProvider();
  ProductsRouter();

  Handler get router {
    final router = Router();
    router.post('/add_product', productService.createProductHandler);
    router.post('/update_product', productService.updateProductHandler);
    router.get('/products', productService.getAllProductsHandler);
    router.get('/products/<id>', productService.getProductHandler);
    router.delete('/delete_product', productService.removeProductHandler);
    router.post('/add_multiple_product', productService.createMultipleProductHandler);
    router.post('/update_multiple_product', productService.updateMultipleProductHandler);
    var pipeline = Pipeline().addMiddleware(authProvider.requireAuth());
    return pipeline.addHandler(router.call);
  }
}
