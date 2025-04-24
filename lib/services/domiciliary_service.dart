import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/domiciliary-model/domiciliary_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing client-related operations.
class ClientService {
  /// Constructor for [ClientService].
  ClientService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a client by their unique ID.
  Future<Either<Failure, DomiciliaryModel>> getClient(
    String clientId,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(domiciliaryCollection, clientId);
      if (snapshot.isEmpty) {
        throw Exception('Client not found');
      }
      return Right(DomiciliaryModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch client: $e',
        ),
      );
    }
  }

  /// Fetches all clients from Firestore.
  Future<Either<Failure, List<DomiciliaryModel>>> getAllClients() async {
    try {
      final snapshot = await _firestoreHelper.getCollection(
        domiciliaryCollection,
      );

      final clients = snapshot.docs
          .map((doc) => DomiciliaryModel.fromSnapshot(doc.data()))
          .toList();
      return Right(clients);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch clients: $e',
        ),
      );
    }
  }

  /// Creates a new client in Firestore.
  Future<Either<Failure, String>> createClient(
    DomiciliaryModel client,
  ) async {
    try {
      final clientData = client.toSnapshot();
      final clientId = await _firestoreHelper.addDocument(
        domiciliaryCollection,
        clientData,
        documentId: client.clientId,
      );
      return Right(clientId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create client: $e',
        ),
      );
    }
  }

  /// Updates an existing client in Firestore.
  Future<Either<Failure, String>> updateClient(
    DomiciliaryModel client,
  ) async {
    try {
      final clientData = client.toSnapshot();

      await _firestoreHelper.updateDocument(
        domiciliaryCollection,
        client.clientId,
        clientData,
      );

      return Right(client.clientId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update client: $e',
        ),
      );
    }
  }

  /// Deletes a client from Firestore.
  Future<Either<Failure, String>> deleteClient(String clientId) async {
    try {
      await _firestoreHelper.deleteDocument(domiciliaryCollection, clientId);
      return Right(clientId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete client: $e',
        ),
      );
    }
  }
}
