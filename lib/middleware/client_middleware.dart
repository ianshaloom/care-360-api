import 'package:care360/services/client_service.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware to inject the CaregiverService into the request context.
Middleware clientServiceMiddleware() {
  return (handler) {
    return (context) async {
      // Get the Firebase Admin instance from the request context
      final admin = context.read<FirebaseAdminApp>();

      // Firestore initialization
      final firestore = Firestore(admin);

      // Initialize FirestoreHelper and ClientService
      final firestoreHelper = FirestoreHelper(firestore);
      final clientService = ClientService(firestoreHelper);

      // Inject the service into the request context
      final newContext = context.provide<ClientService>(() => clientService);

      // Pass the request to the next handler
      return handler(newContext);
    };
  };
}
