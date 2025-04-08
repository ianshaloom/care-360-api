/*
import 'package:care360/errors/firestore_exceptions.dart';
import 'package:firedart/firedart.dart';

/// This class is used to interact with Firestore
class AuthHelper {
  /// Firestore instance
  final Firestore _firestore = Firestore.instance;

  /// Get all documents from a collection
  Future<String> verifyIdToken(String documentId) async {
    try {
      final document = await _firestore
          .collection('care-360-users')
          .document(documentId)
          .get();

      if (document.map != null) {
        return null;
      }
    } catch (e) {
      throw FireDartGetException(message: 'Firestore Error: $e');
    }
  }

  var firebaseAuth = FirebaseAuth(apiKey);
}
*/
