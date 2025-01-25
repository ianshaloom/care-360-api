/*
import 'package:care360/models/care-giver-model/care_giver_model.dart';
import 'package:care360/services/caregiver_service.dart';
import 'package:care360/utils/firestore_helper.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Mock FirestoreHelper
class MockFirestoreHelper extends Mock implements FirestoreHelper {}

// Mock QuerySnapshot
class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

// Mock QueryDocumentSnapshot
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('CaregiverService Tests', () {
    late CaregiverService caregiverService;
    late MockFirestoreHelper mockFirestoreHelper;

    setUp(() {
      mockFirestoreHelper = MockFirestoreHelper();
      caregiverService = CaregiverService(mockFirestoreHelper);
    });

    // Test for getCaregiver
    test('getCaregiver - should return a CaregiverModel when caregiver exists',
        () async {
      const caregiverId = 'caregiver123';
      final mockSnapshot = {'name': 'John Doe', 'caregiverId': caregiverId};

      // Mock FirestoreHelper response
      when(() => mockFirestoreHelper.getDocument('caregivers', caregiverId))
          .thenAnswer((_) async => mockSnapshot);

      final result = await caregiverService.getCaregiver(caregiverId);

      expect(result, isA<CaregiverModel>());
      expect(result.caregiverId, caregiverId);
    });

    test(
        'getCaregiver - should throw an exception when caregiver does not exist',
        () async {
      const caregiverId = 'nonexistent123';

      // Mock FirestoreHelper response
      when(() => mockFirestoreHelper.getDocument('caregivers', caregiverId))
          .thenAnswer((_) async => {});

      expect(() async => caregiverService.getCaregiver(caregiverId),
          throwsException);
    });

    // Test for getAllCaregivers
    test('getAllCaregivers - should return a list of CaregiverModel', () async {
      // Create mock documents
      final mockDocument1 = MockQueryDocumentSnapshot();
      final mockDocument2 = MockQueryDocumentSnapshot();

      when(mockDocument1.data)
          .thenReturn({'name': 'John Doe', 'caregiverId': 'caregiver123'});
      when(mockDocument2.data)
          .thenReturn({'name': 'Jane Doe', 'caregiverId': 'caregiver456'});

      // Create a mock QuerySnapshot
      final mockQuerySnapshot = MockQuerySnapshot();
      when(() => mockQuerySnapshot.docs)
          .thenReturn([mockDocument1, mockDocument2]);

      // Mock FirestoreHelper response
      when(() => mockFirestoreHelper.getCollection('caregivers'))
          .thenAnswer((_) async => mockQuerySnapshot);

      final result = await caregiverService.getAllCaregivers();

      expect(result, isA<List<CaregiverModel>>());
      expect(result.length, 2);
    });

    // Test for createCaregiver
    test(
        'createCaregiver - should return the document ID of the created caregiver',
        () async {
      const documentId = 'newCaregiver123';
      final caregiver = CaregiverModel(
        name: 'John Doe',
        caregiverId: 'caregiver123',
        uid: 'uid123',
        phone: '1234567890',
        qualifications: ['BSc'],
        availability: ['Monday'],
        assignedShifts: ['shift123'],
        registeredCode: 'code123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Mock FirestoreHelper response
      when(() => mockFirestoreHelper.addDocument(
              'caregivers', caregiver.toSnapshot()))
          .thenAnswer((_) async => documentId);

      final result = await caregiverService.createCaregiver(caregiver);

      expect(result, documentId);
    });

    // Test for updateCaregiver
    test('updateCaregiver - should update the caregiver successfully',
        () async {
      final caregiver = CaregiverModel(
        name: 'John Doe',
        caregiverId: 'caregiver123',
        uid: 'uid123',
        phone: '1234567890',
        qualifications: ['BSc'],
        availability: ['Monday'],
        assignedShifts: ['shift123'],
        registeredCode: 'code123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Mock FirestoreHelper response
      when(
        () => mockFirestoreHelper.updateDocument(
          'caregivers',
          caregiver.caregiverId,
          caregiver.toSnapshot(),
        ),
      ).thenAnswer((_) async {});

      expect(() async => caregiverService.updateCaregiver(caregiver),
          returnsNormally);
    });

    // Test for deleteCaregiver
    test('deleteCaregiver - should delete the caregiver successfully',
        () async {
      const caregiverId = 'caregiver123';

      // Mock FirestoreHelper response
      when(() => mockFirestoreHelper.deleteDocument('caregivers', caregiverId))
          .thenAnswer((_) async {});

      expect(
        () async => caregiverService.deleteCaregiver(caregiverId),
        returnsNormally,
      );
    });
  });
}
*/
