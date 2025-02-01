import 'package:care360/middleware/admin_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the admin route
Handler middleware(Handler handler) {
  return handler.use(adminServiceMiddleware());
}
