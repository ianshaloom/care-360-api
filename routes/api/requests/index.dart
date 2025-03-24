import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/services/request_service.dart';
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
    final repo = context.read<RequestService>();

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');

    // List of request maps
    var request = <Map<String, dynamic>>[];

    final response = await repo.getAllRequests();

    response.fold(
      (f) => failure = f,
      (s) => request = RequestModel.modelsToJsons(s),
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: request);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final repo = context.read<RequestService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    // Create a new request
    final response = await repo.createRequest(
      RequestModel.fromSnapshot(data),
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
        'message': 'Request created successfully {$success}',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
