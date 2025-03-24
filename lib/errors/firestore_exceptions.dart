/// This file contains custom exceptions that are thrown when
/// an error occurs during communication with the database.
///
/// This is the abstract class for the FireDartException.
class FireDartException implements Exception {
  /// This is the error message that will be displayed to the user.
  FireDartException(
      {this.message =
          'An error occurred during communication with the database.',});

  /// This is the constructor for the FireDartException class.
  final String message;

  @override
  String toString() => message;
}

/// This is the class for the failure of the application.
class FireDartGetException extends FireDartException {
  /// This is the constructor for the FDFetchException class.
  FireDartGetException({required super.message});
}

/// This is the class for the success of the application.
class FireDartSetException extends FireDartException {
  /// This is the constructor for the FDNotSavedException class.
  FireDartSetException({required super.message});
}

/// This is the class for the failure of the application.
class FireDartUpdateException extends FireDartException {
  /// This is the constructor for the FireDartNotUpdatedException class.
  FireDartUpdateException({required super.message});
}

/// This is the class for the failure of the application.
class FireDartDeleteException extends FireDartException {
  /// This is the constructor for the FireDartNotDeletedException class.
  FireDartDeleteException({required super.message});
}

/// This is the class for the failure of the application.
class FireDartGenericException extends FireDartException {
  /// This is the constructor for the FireDartGenericException class.
  FireDartGenericException({required super.message});
}
