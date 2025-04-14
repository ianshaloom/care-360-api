import 'package:care360/services/caregiver_service.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware to inject the CaregiverService into the request context.
Middleware caregiverServiceMiddleware() {
  return (handler) {
    return (context) async {
      // Get the Firebase Admin instance from the request context
      final admin = context.read<FirebaseAdminApp>();

      // Firestore initialization
      final firestore = Firestore(admin);

      // Initialize FirestoreHelper and CaregiverService
      final firestoreHelper = FirestoreHelper(firestore);
      final caregiverService = CareGiverService(firestoreHelper);

      // Inject the service into the request context
      final newContext =
          context.provide<CareGiverService>(() => caregiverService);

      // Pass the request to the next handler
      return handler(newContext);
    };
  };
}
