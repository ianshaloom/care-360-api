import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/services/shift_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id);
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.patch:
      return _patch(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(Response(statusCode: HttpStatus.methodNotAllowed));
  }
}

Future<Response> _get(RequestContext context, String id) async {
  try {
    final repo = context.read<ShiftService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');

    // Shift model
    var shift = ShiftModel.empty();

    final response = await repo.getShift(id);

    response.fold(
      (f) => failure = f,
      (s) => shift = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: shift.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _delete(RequestContext context, String id) async {
  try {
    final repo = context.read<ShiftService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.deleteShift(id);

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
        'message': 'Shift deleted successfully {$success}',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _patch(RequestContext context, String id) async {
  try {
    final repo = context.read<ShiftService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateShift(
      ShiftModel.fromSnapshot(data),
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
        'message': 'Shift updated successfully {$success}',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
