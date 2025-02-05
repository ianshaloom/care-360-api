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

  /// Fetches a single document from a Referenced Firestore sub-collection.
  Future<Map<String, dynamic>> getSubDocument(
    String collection,
    String documentId,
    String subCollection,
    String subDocId,
  ) async {
    final snapshot = await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocId)
        .get();
    return snapshot.data() ?? {};
  }

  /// Fetches all documents from a Firestore collection.
  Future<QuerySnapshot<Map<String, Object?>>> getCollection(
    String collection,
  ) async {
    return _firestore.collection(collection).get();
  }

  /// Fetch all documents from a Referenced Firestore sub-collection.
  Future<QuerySnapshot<Map<String, Object?>>> getSubCollection(
    String collection,
    String documentId,
    String subCollection,
  ) async {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .get();
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

  /// Add a new document to a Referenced Firestore sub-collection.
  Future<void> addSubDocument(
    String collection,
    String documentId,
    String subCollection,
    Map<String, dynamic> data, {
    String? subDocId,
  }) async {
    final docRef = await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocId)
        .set(data);
  }

  /// Updates an existing document in Firestore.
  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  /// Updates an existing document in a Referenced Firestore sub-collection.
  Future<void> updateSubDocument(
    String collection,
    String documentId,
    String subCollection,
    String subDocId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocId)
        .update(data);
  }

  /// Deletes a document from Firestore.
  Future<void> deleteDocument(
    String collection,
    String documentId,
  ) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  /// Deletes a document from a Referenced Firestore sub-collection.
  Future<void> deleteSubDocument(
    String collection,
    String documentId,
    String subCollection,
    String subDocId,
  ) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocId)
        .delete();
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

  /// Runs a query on a Firestore collection with multiple filters.
  Future<QuerySnapshot<Map<String, Object?>>>
      queryCollectionWithMultipleFilters(
    String collection, {
    List<String>? fields,
    List<WhereFilter>? filters,
    List<dynamic>? values,
    int? limit,
    String? orderByField,
    bool? descending,
  }) async {
    Query<Map<String, Object?>> query = _firestore.collection(collection);

    // Add where clause
    if (fields != null && filters != null) {
      for (var i = 0; i < fields.length; i++) {
        query = query.where(fields[i], filters[i], values![i]);
      }
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
