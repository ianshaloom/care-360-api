import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/services/shift_service.dart';
import 'package:dart_frog/dart_frog.dart';

/// Handles matching of caregivers to requests.
/// API endpoint: GET /api/requests/:id/float

Future<Response> onRequest(RequestContext context, String id) {
  switch (context.request.method) {
    case HttpMethod.get:
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
      return _patch(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(Response(statusCode: HttpStatus.methodNotAllowed));
  }
}

Future<Response> _patch(RequestContext context, String id) async {
  try {
    final repo = context.read<ShiftService>();
    final data =  await context.request.json() as Map<String, dynamic>;

    final clockIn = data['clockInTime'] as String;
    final location = data['clockInLocation'] as Map<String, dynamic>;

    // Failure object
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.clockInCaregiver(
      id,
      clockInTime: clockIn,
      clockInLocation: location,
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
        'message': success,
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
