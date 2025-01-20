import 'dart:io';

import 'package:care360/data/care360_repository.dart';
import 'package:care360/errors/failure_n_success.dart';
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
      return _patch(context);
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(Response(statusCode: HttpStatus.methodNotAllowed));
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final repo = context.read<Care360Repository>();
    final id = context.request.headers['id']!;

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var activation = <String, dynamic>{};

    final response = await repo.getActivation(id);

    response.fold(
      (f) => failure = f,
      (s) => activation = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: activation);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final repo = context.read<Care360Repository>();
    final id = context.request.headers['id']!;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.postActivation(id);

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

    return Response.json(body: success);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _patch(RequestContext context) async {
  try {
    final repo = context.read<Care360Repository>();
    final data = await context.request.json() as Map<String, dynamic>;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateActivation(data);

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

    return Response.json(body: success);
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
