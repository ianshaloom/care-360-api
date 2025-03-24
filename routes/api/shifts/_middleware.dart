import 'package:care360/middleware/shift_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the shift route
Handler middleware(Handler handler) {
  return handler.use(shiftServiceMiddleware());
}
