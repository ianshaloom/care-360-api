import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-home-model/care_home_model.dart';
import 'package:care360/services/carehome_service.dart';
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
    final repo = context.read<CareHomeService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');

    // Care home object
    var careHome = CareHomeModel.empty();

    final response = await repo.getCareHome(id);

    response.fold(
      (f) => failure = f,
      (s) => careHome = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: careHome.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _delete(RequestContext context, String id) async {
  try {
    final repo = context.read<CareHomeService>();

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.deleteCareHome(id);

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
        'message': 'Care home deleted successfully {$success}',
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
    final repo = context.read<CareHomeService>();
    final data = await context.request.json() as Map<String, dynamic>;

    // Failure and result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateCareHome(
      CareHomeModel.fromSnapshot(data),
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
        'message': 'Care home updated successfully {$success}',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
