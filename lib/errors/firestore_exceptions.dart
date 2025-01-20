/// This file contains custom exceptions that are thrown when
/// an error occurs during communication with the database.
///
/// This is the abstract class for the FireDartException.
class FireDartException implements Exception {
  /// This is the error message that will be displayed to the user.
  FireDartException(
      {this.message =
          'An error occurred during communication with the database.'});

  /// This is the constructor for the FireDartException class.
  final String message;

  @override
  String toString() => message;
}

/// This is the class for the failure of the application.
class FDFetchException extends FireDartException {
  /// This is the constructor for the FDFetchException class.
  FDFetchException({required super.message});
}

/// This is the class for the success of the application.
class FDNotSavedException extends FireDartException {
  /// This is the constructor for the FDNotSavedException class.
  FDNotSavedException({required super.message});
}

/// This is the class for the failure of the application.
class FDNotUpdatedException extends FireDartException {
  /// This is the constructor for the FDNotUpdatedException class.
  FDNotUpdatedException({required super.message});
}

/// This is the class for the failure of the application.
class FDNotDeletedException extends FireDartException {
  /// This is the constructor for the FDNotDeletedException class.
  FDNotDeletedException({required super.message});
}

/// This is the class for the failure of the application.
class FDGenericException extends FireDartException {
  /// This is the constructor for the FDGenericException class.
  FDGenericException({required super.message});
}
