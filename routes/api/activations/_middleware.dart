import 'package:care360/middleware/activation_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the activation route
Handler middleware(Handler handler) {
  return handler.use(activationServiceMiddleware());
}
