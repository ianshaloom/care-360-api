import 'package:care360/middleware/client_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the client route
Handler middleware(Handler handler) {
  return handler.use(clientServiceMiddleware());
}
