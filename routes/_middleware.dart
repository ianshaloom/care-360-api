import 'dart:io';

import 'package:care360/data/care360_repository.dart';
import 'package:care360/data/firestore_ds.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';

import '../main.dart';

Handler middleware(Handler handler) {
  final h = handler
      .use(
        requestLogger(),
      )
      .use(
        repoMiddleware,
      )
      .use(
        firebaseAdminMiddleware,
      );

  return h;
}

Handler repoMiddleware(Handler handler) {
  return (RequestContext context) async {
    final response = await handler.use(
      provider<Care360Repository>(
        (_) {
          final admin = context.read<FirebaseAdminApp>();

          return Care360Repository(
            FirestoreDs(
              Firestore(admin),
            ),
          );
        },
      ),
    ).call(context);

    return response;
  };
}

Handler firebaseAdminMiddleware(Handler handler) {
  return (context) {
    // Access the Firebase Admin instance
    final admin = firebaseAdmin;

    if (admin == null) {
      return Response.json(
        body: {'error': 'Firebase Admin SDK not initialized'},
        statusCode: HttpStatus.internalServerError,
      );
    }

    // Attach the Firebase Admin instance to the request context
    final updatedContext = context.provide<FirebaseAdminApp>(() => admin);

    // Continue to the next handler
    return handler(updatedContext);
  };
}
