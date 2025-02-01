import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/models/request-model/request_model.dart';
import 'package:care360/services/messaging_service.dart';
import 'package:care360/services/shift_service.dart';
import 'package:care360/utils/firestore_helper.dart';
import 'package:care360/utils/messaging_helper.dart';
import 'package:care360/utils/request_matching_algo.dart';
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
      final request = requestModel.toJson();

      // add the request to the request collection
      final requestId = await _firestoreHelper.addDocument(
        requestCollection,
        request,
        documentId: requestModel.requestId,
      );

      // Notify the admins that a request has been created
      MessagingService(_messagingHelper, _firestoreHelper).multicast(
        'New Request',
        'A new request has been created by ${requestModel.requestId}',
        user: 'admin',
      );

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

  /// Match a request with a care giver
  Future<Either<Failure, String>> matchRequestWithCaregiver(
    RequestModel request,
  ) async {
    try {
      // Fetch all caregivers
      final snapshot = await _firestoreHelper.getCollection(
        caregiverCollection,
      );

      final caregivers = snapshot.docs
          .map((doc) => CareGiverModel.fromSnapshot(doc.data()))
          .toList();

      // Match caregivers with the request
      final caregiver = await CaregiverMatchingAlgorithm.matchedCaregiver(
        request,
        caregivers,
        ShiftService(_firestoreHelper, _messagingHelper),
      );

      if (caregiver == null) {
        return Left(
          GevericFailure(
            errorMessage: 'No available care givers found, check timeline',
          ),
        );
      }

      // Update the request with the caregiver id
      final assignedRequest = request.copyWith(
        assignedCaregiverId: caregiver.caregiverId,
        status: RequestStatus.assigned,
        updatedAt: DateTime.now(),
      );

      final r = await updateRequest(assignedRequest);
      // --- if error, return error
      if (r.isLeft()) {
        return r;
      }

      // Create a new shift from the request
      final shiftService = ShiftService(_firestoreHelper, _messagingHelper);
      final shifts = assignedRequest.generateShifts();

      for (final shift in shifts) {
        await shiftService.createShift(
          shift,
          collection: scheduledShiftCollection,
        );
        // --- if error, return error
        if (r.isLeft()) {
          return r;
        }
      }

      // Notify the caregiver
      MessagingService(_messagingHelper, _firestoreHelper).send(
        'Request Assigned',
        'A request has been assigned to you',
        userId: caregiver.caregiverId,
      );

      // Notify the care home
      MessagingService(_messagingHelper, _firestoreHelper).send(
        'Request Assigned',
        'A request has been assigned to ${caregiver.caregiverId}',
        userId: request.careHomeId,
      );

      return Right(caregiver.caregiverId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to match request with caregiver: $e',
        ),
      );
    }
  }

  /// Float a Request
  Future<Either<Failure, String>> floatRequest(String requestId) async {
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

    /// ToDo - Implement the cache mechanism for caregivers

    // Fetch all caregivers
    final snapshot = await _firestoreHelper.getCollection(
      caregiverCollection,
    );

    final caregivers = snapshot.docs
        .map((doc) => CareGiverModel.fromSnapshot(doc.data()))
        .toList();

    // get all available caregivers
    final careGivers = await CaregiverMatchingAlgorithm.matchedCaregivers(
      requestModel,
      caregivers,
      ShiftService(_firestoreHelper, _messagingHelper),
    );

    // if is empty, return error
    if (careGivers.isEmpty) {
      return Left(
        GevericFailure(
          errorMessage: 'No available care givers found, check timeline',
        ),
      );
    }

    // Update the request status
    final floatedRequest = requestModel.copyWith(
      status: RequestStatus.floating,
      updatedAt: DateTime.now(),
    );

    final r = await updateRequest(floatedRequest);
    // if error, return error
    if (result.isLeft()) {
      // throw an error
      return r;
    }

    // Notify the care home
    MessagingService(_messagingHelper, _firestoreHelper).send(
      'Request Floated',
      'A request has been floated to caregivers',
      userId: requestModel.careHomeId,
    );

    // Notify the caregivers
    // -- get all the tokens of the caregivers
    final tokens = <String>[];
    for (final careGiver in careGivers) {
      tokens.add(careGiver.notificationToken!);
    }

    // -- send the notification
    MessagingService(_messagingHelper, _firestoreHelper).multicast(
      'New Request',
      'A new request has been floated to you',
      notifTokens: tokens,
    );

    return const Right('Request floated');
  }

  /// Accept Request
  Future<Either<Failure, String>> acceptRequest(
    String requestId,
    String caregiverId,
  ) async {
    try {
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

      // check if caregiver is
      // Update the request with the caregiver id
      final assignedRequest = request.copyWith(
        status: RequestStatus.assigned,
        assignedCaregiverId: caregiverId,
        updatedAt: DateTime.now(),
      );

      final r = await updateRequest(assignedRequest);
      // --- if error, return error
      if (result.isLeft()) {
        return r;
      }

      // Create a new shift from the request
      final shiftService = ShiftService(_firestoreHelper, _messagingHelper);
      final shifts = assignedRequest.generateShifts();

      for (final shift in shifts) {
        await shiftService.createShift(
          shift,
          collection: scheduledShiftCollection,
        );
        // --- if error, return error
        if (result.isLeft()) {
          return r;
        }
      }

      // Notify the care home
      MessagingService(_messagingHelper, _firestoreHelper).send(
        'Request Accepted',
        'A request has been accepted by $caregiverId',
        userId: requestModel.careHomeId,
      );

      return const Right('Request accepted');
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to accept request: $e',
        ),
      );
    }
  }
}
