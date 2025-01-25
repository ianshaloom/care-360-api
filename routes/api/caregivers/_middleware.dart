import 'package:care360/middleware/care_giver_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Apply the middleware to the caregiver route
Handler middleware(Handler handler) {
  return handler.use(caregiverServiceMiddleware());
}
