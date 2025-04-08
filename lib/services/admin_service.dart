import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/admin-model/admin_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing admin-related operations.
class AdminService {
  /// Constructor for [AdminService].
  AdminService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches an admin by their unique ID.
  Future<Either<Failure, AdminModel>> getAdmin(
    String adminId,
  ) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(adminCollection, adminId);
      if (snapshot.isEmpty) {
        throw Exception('Admin not found');
      }
      return Right(AdminModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch admin: $e',
        ),
      );
    }
  }

  /// Fetches all admins from Firestore.
  Future<Either<Failure, List<AdminModel>>> getAllAdmins() async {
    try {
      final snapshot = await _firestoreHelper.getCollection(adminCollection);

      final admins = snapshot.docs
          .map((doc) => AdminModel.fromSnapshot(doc.data()))
          .toList();
      return Right(admins);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch admins: $e',
        ),
      );
    }
  }

  /// Creates a new admin in Firestore.
  Future<Either<Failure, String>> createAdmin(
    AdminModel admin,
  ) async {
    try {
      final adminData = admin.toDoc();
      final adminId = await _firestoreHelper.addDocument(
        adminCollection,
        adminData,
        documentId: admin.uid,
      );
      return Right(adminId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create admin: $e',
        ),
      );
    }
  }

  /// Updates an existing admin in Firestore.
  Future<Either<Failure, String>> updateAdmin(
    AdminModel admin,
  ) async {
    try {
      final adminData = admin.toJson();

      await _firestoreHelper.updateDocument(
        adminCollection,
        admin.uid,
        adminData,
      );

      return Right(admin.uid);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update admin: $e',
        ),
      );
    }
  }

  /// Deletes an admin from Firestore.
  Future<Either<Failure, String>> deleteAdmin(String adminId) async {
    try {
      await _firestoreHelper.deleteDocument(adminCollection, adminId);
      return Right(adminId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete admin: $e',
        ),
      );
    }
  }
}
