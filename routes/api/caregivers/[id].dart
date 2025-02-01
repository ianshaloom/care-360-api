import 'dart:io';

import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/services/caregiver_service.dart';
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
    final repo = context.read<CareGiverService>();

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');

    // List of caregivers maps
    var careGiver = CareGiverModel.empty();

    final response = await repo.getCaregiver(id);

    response.fold(
      (f) => failure = f,
      (s) => careGiver = s,
    );

    if (failure.errorMessage.isNotEmpty) {
      final error = failure.errorMessage;

      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': error},
      );
    }

    return Response.json(body: careGiver.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}

Future<Response> _delete(RequestContext context, String id) async {
  try {
    final repo = context.read<CareGiverService>();

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.deleteCaregiver(id);

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
        'message': 'Caregiver deleted successfully {$success}',
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
    final repo = context.read<CareGiverService>();
    final data = await context.request.json() as Map<String, dynamic>;

    //  failure n result
    Failure failure = EmptyFailure(errorMessage: '');
    var success = '';

    final response = await repo.updateCaregiver(
      CareGiverModel.fromSnapshot(data),
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
        'message': 'Caregiver updated successfully {$success}',
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: e.toString(),
    );
  }
}
