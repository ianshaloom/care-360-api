import 'package:care360/middleware/care_home_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the care home route
Handler middleware(Handler handler) {
  return handler.use(careHomeServiceMiddleware());
}
