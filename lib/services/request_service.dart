import 'dart:async';

import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/services/messaging_service.dart';
import 'package:care360/utils/assign_shift_algo.dart';
import 'package:care360/utils/data/success_response.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:care360/utils/helpers/messaging_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing request-related operations.
class RequestService {
  /// Constructor for [RequestService].
  RequestService(this._firestoreHelper, this._messagingHelper);

  final FirestoreHelper _firestoreHelper;
  final MessagingHelper _messagingHelper;

  /// Fetches a client by their unique ID.
  Future<Either<Failure, RequestModel>> getRequest(
    String requestId, {
    String requestCollection = requestCollection,
  }) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(requestCollection, requestId);
      if (snapshot.isEmpty) {
        throw Exception('Request not found');
      }
      return Right(RequestModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch request: $e',
        ),
      );
    }
  }

  /// Fetches all requests from Firestore.
  Future<Either<Failure, List<RequestModel>>> getAllRequests() async {
    try {
      final snapshot = await _firestoreHelper.getCollection(requestCollection);

      final requests = snapshot.docs
          .map((doc) => RequestModel.fromSnapshot(doc.data()))
          .toList();

      return Right(requests);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch requests: $e',
        ),
      );
    }
  }

  /// Creates a new request in Firestore.
  Future<Either<Failure, String>> createRequest(
    RequestModel requestModel,
  ) async {
    try {
      final request = requestModel.toDoc();

      // add the request to the request collection
      final requestId = await _firestoreHelper.addDocument(
        requestCollection,
        request,
        documentId: requestModel.requestId,
      );

      // Notify the admins that a request has been created
      unawaited(MessagingService(_messagingHelper, _firestoreHelper).multicast(
        'New Request',
        'A new request has been created by ${requestModel.requestId}',
        user: 'admin',
      ));

      return Right(requestId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create request: $e',
        ),
      );
    }
  }

  /// Updates an existing client in Firestore.
  Future<Either<Failure, String>> updateRequest(
    RequestModel requestModel,
  ) async {
    try {
      final request = requestModel.toJson();

      await _firestoreHelper.updateDocument(
        requestCollection,
        requestModel.requestId,
        request,
      );

      return Right(requestModel.requestId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update request: $e',
        ),
      );
    }
  }

  /// Updates a specific field in an existing request in Firestore.
  Future<Either<Failure, String>> updateRequestField(
    String requestId,
    String field,
    dynamic value,
  ) async {
    try {
      await _firestoreHelper.updateDocumentField(
        requestCollection,
        requestId,
        field,
        value,
      );

      return Right(requestId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update request field: $e',
        ),
      );
    }
  }

  /// Deletes a client from Firestore.
  Future<Either<Failure, String>> deleteRequest(String requestId) async {
    try {
      await _firestoreHelper.deleteDocument(requestCollection, requestId);
      return Right(requestId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete request: $e',
        ),
      );
    }
  }

  /// Float a Request
  Future<Either<Failure, String>> floatRequest(String requestId) async {
    try {
      final shiftAlgo = ShiftAlgorithm(_firestoreHelper, _messagingHelper);

      // fetch the request
      final result = await getRequest(requestId);

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        return Left(
          GevericFailure(
            errorMessage: failure!.errorMessage,
          ),
        );
      }

      // -- check if request is still open
      final request = result.fold((l) => null, (r) => r);
      final requestModel = request!;
      if (requestModel.status != RequestStatus.open) {
        return Left(
          GevericFailure(
            errorMessage: 'Request is no longer open',
          ),
        );
      }

      // Float the request
      await shiftAlgo.floatRequestShifts(requestModel);

      // update the request status
      await updateRequestField(
        requestId,
        'status',
        'floating',
      );

      return const Right('Request floated');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to float request: $e',
        ),
      );
    }
  }

  /// Accept Request
  Future<Either<Failure, String>> acceptFloatedShiftFromRequest(
    String requestId,
    String shiftId,
    String caregiverId,
  ) async {
    try {
      final shiftAlgo = ShiftAlgorithm(_firestoreHelper, _messagingHelper);

      // accept the request
      final accepted = await shiftAlgo.acceptRequestShift(
        requestId,
        shiftId,
        caregiverId,
      );

      if (accepted) {
        // check if their is still any shift left floating
        const collection = requestCollection;
        const subCollection = assignableShiftCollection;
        // fetch the request
        final result = await _firestoreHelper.querySubCollectionWithOneFilter(
          collection,
          requestId,
          subCollection,
          field: 'floatStatus',
          value: 'floating',
          filter: WhereFilter.equal,
          limit: 1,
        );

        // check if the result is empty
        if (result.docs.isEmpty) {
          // update the request status
          await updateRequestField(
            requestId,
            'status',
            'assigned',
          );
        }
      }

      return Right(SuccessResponse.acceptShiftSuccessMessage);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to accept request: $e',
        ),
      );
    }
  }

  /// Distribute Shifts
  Future<Either<Failure, String>> distributeShifts(String requestId) async {
    try {
      final shiftAlgo = ShiftAlgorithm(_firestoreHelper, _messagingHelper);

      // fetch the request
      final result = await getRequest(requestId);

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        return Left(
          GevericFailure(
            errorMessage: failure!.errorMessage,
          ),
        );
      }

      // -- check if request is still open
      final request = result.fold((l) => null, (r) => r);
      final requestModel = request!;
      if (requestModel.status != RequestStatus.open) {
        return Left(
          GevericFailure(
            errorMessage: 'Request is no longer open',
          ),
        );
      }

      // Distribute the shifts
      await shiftAlgo.assignShiftsFromRequest(requestModel);

      return const Right('Shifts distributed');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to distribute shifts: $e',
        ),
      );
    }
  }
}
