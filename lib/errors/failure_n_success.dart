/// This file contains the classes for the
/// failure and success of the application.
///
/// This is the abstract class for the success of the application.
abstract class Failure {
  /// This is the constructor for the Failure class.
  const Failure({required this.errorMessage});

  /// This is the error message that will be displayed to the user.
  final String errorMessage;
}

/// This is the abstract class for the success of the application.
abstract class Success {
  /// This is the constructor for the Success class.
  const Success({required this.successContent});

  /// This is the success message that will be displayed to the user.
  final String successContent;
}

/// This is the class for the failure of the application.
class FirestoreFailure extends Failure {
  /// This is the constructor for the FirestoreFailure class.
  FirestoreFailure({required super.errorMessage});
}

/// This is the class for the success of the application.
class FirestoreSuccess extends Success {
  /// This is the constructor for the FirestoreSuccess class.
  FirestoreSuccess({required super.successContent});
}

/// This is the class for the failure of the application.
class GevericFailure extends Failure {
  /// This is the constructor for the GevericFailure class.
  GevericFailure({required super.errorMessage});
}

/// This is the class for the success of the application.
class GevericSuccess extends Success {
  /// This is the constructor for the GevericSuccess class.
  GevericSuccess({required super.successContent});
}

/// This is the class for the empty failure of the application.
class EmptyFailure extends Failure {
  /// This is the constructor for the EmptyFailure class.
  EmptyFailure({required super.errorMessage});
}
