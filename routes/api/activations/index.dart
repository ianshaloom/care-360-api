import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/activation-model/activation_model.dart';
import 'package:care360/services/activation_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.put:
    case HttpMethod.delete:
      return _delete(context);
    case HttpMethod.patch:
      return _patch(context);
    case HttpMethod.head:
    case HttpMethod.options:
      return Future.value(Response(statusCode: HttpStatus.methodNotAllowed));
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final repo = context.read<ActivationService>();
    final email = context.request.headers['email']!;

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var activation = <String, dynamic>{};

    final response = await repo.getActivation(email);

    response.fold(
      (f) => failure = f,
      (s) => activation = s.toSnapshot(),
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
    final repo = context.read<ActivationService>();
    final email = context.request.headers['email']!;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.createActivation(email);

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
        'message': 'Activation created successfuly: $success',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _patch(RequestContext context) async {
  try {
    final repo = context.read<ActivationService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateActivation(
      ActivationModel.fromSnapshot(data),
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
        'message': 'Activation created successfuly: $success',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _delete(RequestContext context) async {
  try {
    final repo = context.read<ActivationService>();
    final email = context.request.headers['email']!;

    // failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.deleteActivation(email);

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
        'message': 'Activation deleted successfully: $success',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
