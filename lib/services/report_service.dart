import 'package:care360/constants/constants.dart';
import 'package:care360/errors/failure_n_success.dart';
import 'package:care360/models/report-model/report_model.dart';
import 'package:care360/utils/helpers/firestore_helper.dart';
import 'package:dartz/dartz.dart';

/// Service class for managing report-related operations.
class ReportService {
  /// Constructor for [ReportService].
  ReportService(this._firestoreHelper);

  final FirestoreHelper _firestoreHelper;

  /// Fetches a report by their unique ID.
  Future<Either<Failure, ReportModel>> getReport(String reportId) async {
    try {
      final snapshot =
          await _firestoreHelper.getDocument(reportCollection, reportId);
      if (snapshot.isEmpty) {
        throw Exception('Report not found');
      }
      return Right(ReportModel.fromSnapshot(snapshot));
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch report: $e',
        ),
      );
    }
  }

  /// Fetches all reports from Firestore.
  Future<Either<Failure, List<ReportModel>>> getAllReports() async {
    try {
      final snapshot = await _firestoreHelper.getCollection(reportCollection);

      final reports = snapshot.docs
          .map((doc) => ReportModel.fromSnapshot(doc.data()))
          .toList();
      return Right(reports);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to fetch reports: $e',
        ),
      );
    }
  }

  /// Creates a new report in Firestore.
  Future<Either<Failure, String>> createReport(
    ReportModel report,
  ) async {
    try {
      final reportData = report.toSnapshot();
      final reportId = await _firestoreHelper.addDocument(
        reportCollection,
        reportData,
        documentId: report.reportId,
      );
      return Right(reportId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to create report: $e',
        ),
      );
    }
  }

  /// Updates an existing report in Firestore.
  Future<Either<Failure, String>> updateReport(
    ReportModel report,
  ) async {
    try {
      final reportData = report.toSnapshot();

      await _firestoreHelper.updateDocument(
        reportCollection,
        report.reportId,
        reportData,
      );

      return Right(report.reportId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to update report: $e',
        ),
      );
    }
  }

  /// Deletes a report from Firestore.
  Future<Either<Failure, String>> deleteReport(String reportId) async {
    try {
      await _firestoreHelper.deleteDocument(reportCollection, reportId);
      return Right(reportId);
    } catch (e) {
      return Left(
        GevericFailure(
          errorMessage: 'Failed to delete report: $e',
        ),
      );
    }
  }
}
