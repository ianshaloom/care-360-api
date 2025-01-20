import 'dart:io';

import 'package:care360/data/care360_repository.dart';
import 'package:care360/data/firestore_ds.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firestore/firestore.dart';

Handler middleware(Handler handler) {
  final h = handler
      .use(
        requestLogger(),
      )
      .use(
        firebaseMiddleware,
      )
      .use(
        repoMiddleware,
      );

  return h;
}

Handler firebaseMiddleware(Handler handler) {
  return (RequestContext context) async {
    try {
      if (!Firestore.initialized) {
        Firestore.initialize(value!);
      }

      final response = await handler(context);
      return response;
    } on Exception catch (_) {
      return Response(statusCode: HttpStatus.internalServerError);
    }
  };
}

Handler repoMiddleware(Handler handler) {
  return (RequestContext context) async {
    final response = await handler
        .use(
          provider<Care360Repository>(
            (_) => Care360Repository(
              FirestoreDs(
                Firestore.instance,
              ),
            ),
          ),
        )
        .call(context);

    return response;
  };
}

String? value = Platform.environment['FIREBASE_PROJECT_ID'];
