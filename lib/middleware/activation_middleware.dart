import 'package:care360/services/activation_service.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware to inject the ActivationService into the request context.
Middleware activationServiceMiddleware() {
  return (handler) {
    return (context) async {
      // Get the Firebase Admin instance from the request context
      final admin = context.read<FirebaseAdminApp>();

      // Firestore initialization
      final firestore = Firestore(admin);

      // Initialize FirestoreHelper and ActivationService
      final firestoreHelper = FirestoreHelper(firestore);
      final activService = ActivationService(firestoreHelper);

      // Inject the service into the request context
      final newContext = context.provide<ActivationService>(() => activService);

      // Pass the request to the next handler
      return handler(newContext);
    };
  };
}
