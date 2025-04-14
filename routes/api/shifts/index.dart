import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/shift-model/shift_model.dart';
import 'package:care360/services/shift_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(Response(statusCode: HttpStatus.methodNotAllowed));
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final repo = context.read<ShiftService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');

    // List of shifts maps
    var shifts = <Map<String, dynamic>>[];

    final response = await repo.getAllShifts();

    response.fold(
      (f) => failure = f,
      (s) => shifts = ShiftModel.modelsToJsons(s),
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: shifts);
  } catch (e) {
   return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'error': e.toString(),
      },
    );
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final repo = context.read<ShiftService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.createShift(
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
        'message': 'Shift created successfully {$success}',
      },
    );
  } catch (e) {
   return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'error': e.toString(),
      },
    );
  }
}
