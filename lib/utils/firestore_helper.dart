import 'package:dart_firebase_admin/firestore.dart';

/// FirestoreHelper class for interacting with Firestore.
class FirestoreHelper {
  /// FirestoreHelper constructor.
  FirestoreHelper(this._firestore);

  final Firestore _firestore;

  /// Fetches a single document from Firestore.
  Future<Map<String, dynamic>> getDocument(
    String collection,
    String documentId,
  ) async {
    final snapshot =
        await _firestore.collection(collection).doc(documentId).get();
    return snapshot.data() ?? {};
  }

  /// Fetches all documents from a Firestore collection.
  Future<QuerySnapshot<Map<String, Object?>>> getCollection(
    String collection,
  ) async {
    return _firestore.collection(collection).get();
  }

  /// Adds a new document to a Firestore collection.
  Future<String> addDocument(
    String collection,
    Map<String, dynamic> data, {
    String? documentId,
  }) async {
    if (documentId != null) {
      await _firestore.collection(collection).doc(documentId).set(data);
      return documentId;
    }

    final docRef = await _firestore.collection(collection).add(data);
    return docRef.id;
  }

  /// Updates an existing document in Firestore.
  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  /// Deletes a document from Firestore.
  Future<void> deleteDocument(
    String collection,
    String documentId,
  ) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  /// Runs a query on a Firestore collection.
  Future<QuerySnapshot<Map<String, Object?>>> queryCollection(
    String collection, {
    String? field,
    WhereFilter? filter,
    dynamic value,
    int? limit,
    String? orderByField,
    bool? descending,
  }) async {
    Query<Map<String, Object?>> query = _firestore.collection(collection);

    // Add where clause
    if (field != null && filter != null) {
      query = query.where(field, filter, value);
    }

    // Add orderBy clause
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending ?? false);
    }

    // Add limit
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }
}
