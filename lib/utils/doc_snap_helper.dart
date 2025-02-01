import 'package:dart_firebase_admin/firestore.dart';

/// convert a DocumentSnapshot to a Map<String, dynamic>
///
/// This function takes a DocumentSnapshot
/// and converts it to a Map<String, dynamic>

Map<String, dynamic> fromDocumentSnapshot(
  DocumentSnapshot<Map<String, dynamic>> document,
) {
  if (document.data() == null) return {};
  return document.data()!;
}

Map<String, dynamic> fromQuerySnapshot(
  QuerySnapshot<Map<String, dynamic>> query,
) {
  final docs = query.docs;
  final data = docs.map((doc) => doc.data()).toList();
  return {'data': data};
}
