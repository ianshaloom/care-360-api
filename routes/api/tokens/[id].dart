import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/notification-token-model/notification_token_model.dart';
import 'package:care360/services/notification_token_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.patch:
      return _patch(context, id);

    // other methods fall to default
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(
        Response.json(statusCode: HttpStatus.methodNotAllowed, body: {
          'error': 'Method not allowed',
        }),
      );
  }
}

Future<Response> _get(RequestContext context, String id) async {
  try {
    final repo = context.read<NotificationTokenService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');

    // NotifToken object
    var client = NotificationTokenModel.empty();

    final response = await repo.getNotifTokienById(id);

    response.fold(
      (f) => failure = f,
      (s) => client = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: client.toSnapshot());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

Future<Response> _delete(RequestContext context, String id) async {
  try {
    final repo = context.read<NotificationTokenService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.deleteNotifToken(id);

    response.fold(
      (f) => failure = f,
      (s) => success = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(
      body: {
        'message': 'Client deleted successfully {$success}',
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

Future<Response> _patch(RequestContext context, String id) async {
  try {
    final repo = context.read<NotificationTokenService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateNotifToken(
      NotificationTokenModel.fromSnapshot(data),
    );

    response.fold(
      (f) => failure = f,
      (s) => success = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(
      body: {
        'message': 'Client updated successfully {$success}',
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}
