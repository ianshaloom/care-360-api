import 'package:care360/services/shift_service.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:care360/utils/helpers/messaging_helper.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware to inject the ShiftService into the request context.
Middleware shiftServiceMiddleware() {
  return (handler) {
    return (context) async {
      // Get the Firebase Admin instance from the request context
      final admin = context.read<FirebaseAdminApp>();

      // Firestore initialization
      final firestore = Firestore(admin);
      final messaging = Messaging(admin);

      // Initialize FirestoreHelper and ShiftService
      final firestoreHelper = FirestoreHelper(firestore);
      final messagingHelper = MessagingHelper(messaging);

      final shiftService = ShiftService(firestoreHelper, messagingHelper);

      // Inject the service into the request context
      final newContext = context.provide<ShiftService>(() => shiftService);

      // Pass the request to the next handler
      return handler(newContext);
    };
  };
}
