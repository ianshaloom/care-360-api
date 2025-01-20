import 'package:care360/constants/constants.dart';
import 'package:care360/errors/firestore_exceptions.dart';
import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore.dart';

/// FirestoreDs class
class FirestoreDs {
  /// FirestoreDs constructor
  FirestoreDs(this.firestore);

  /// Firestore instance
  final Firestore firestore;

  /// set activation data
  Future<void> setActivation(Map<String, dynamic> data) async {
    try {
      final docId = data['id'] as String;

      await firestore
          .collection(activationCollection)
          .document(docId)
          .set(data);
    } catch (e) {
      throw FDNotSavedException(message: 'Firestore Error: $e');
    }
  }

  /// get activation data by id
  Future<Map<String, dynamic>> getActivation(String id) async {
    try {
      final shopRef = firestore.collection(activationCollection).document(id);

      final shopData = await shopRef.get();

      return shopData.map;
    } catch (e) {
      throw FDFetchException(message: 'Firestore Error: $e');
    }
  }

  /// Update activation data by id
  Future<String> updateActivation(Map<String, dynamic> data) async {
    try {
      final docId = data['id'] as String;

      await firestore
          .collection(activationCollection)
          .document(docId)
          .update(data);

      return 'Success';
    } catch (e) {
      throw FDNotUpdatedException(message: 'Firestore Update Error: $e');
    }
  }
}
