import 'package:care360/constants/constants.dart';
import 'package:care360/errors/firestore_exceptions.dart';
import 'package:care360/models/activation-model/activation_model.dart';
import 'package:dart_firebase_admin/firestore.dart';

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

      await firestore.collection(activationCollection).doc(docId).set(data);
    } catch (e) {
      throw FireDartSetException(message: 'Firestore Error: $e');
    }
  }

  /// get activation data by id
  Future<Map<String, dynamic>> getActivation(String id) async {
    try {
      final shopRef = firestore.collection(activationCollection).doc(id);

      final shopData = await shopRef.get();

      return ActivationModel.fromDocumentSnapshot(shopData).toSnapshot();
    } catch (e) {
      throw FireDartGetException(message: 'Firestore Error: $e');
    }
  }

  /// Update activation data by id
  Future<String> updateActivation(Map<String, dynamic> data) async {
    try {
      final docId = data['id'] as String;

      await firestore.collection(activationCollection).doc(docId).update(data);

      return 'Success';
    } catch (e) {
      throw FireDartUpdateException(message: 'Firestore Update Error: $e');
    }
  }
}
