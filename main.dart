import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:logger/logger.dart';

// Project ID, Client ID, Client Email, and Private Key
String? projectId = Platform.environment['PROJECT_ID'];
String? clientId = Platform.environment['CLIENT_ID'];
String? clientEmail = Platform.environment['CLIENT_EMAIL'];
String? privateKey =
    Platform.environment['PRIVATE_KEY']?.replaceAll(r'\n', '\n');

// Global variable to store the Firebase Admin instance
FirebaseAdminApp? firebaseAdmin;

Future<void> init(InternetAddress ip, int port) async {
  Logger().i('🏁 🏁 🏁 Initializing Firebase Admin SDK... 🏁 🏁 \n');

  // Check if the required environment variables are set
  if (projectId == null ||
      clientId == null ||
      clientEmail == null ||
      privateKey == null) {
    Logger().e('🏁 🏁 Firebase Admin SDK initialization failed! 🏁 🏁 \n');
    Logger().e('🏁 🏁 Please set the required environment variables: '
        'PROJECT_ID, CLIENT_ID, CLIENT_EMAIL, PRIVATE_KEY 🏁 🏁 \n');
    exit(1);
  }

  // Initialize Firebase Admin SDK
  firebaseAdmin = FirebaseAdminApp.initializeApp(
    projectId!,
    Credential.fromServiceAccountParams(
      clientId: clientId!,
      email: clientEmail!,
      privateKey: privateKey!,
    ),
  );

  Logger().i('🏁 🏁 Firebase Admin SDK initialized successfully! 🏁 🏁 \n');
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  // Start the server
  final server = await serve(handler, ip, port);

  /*print(
    '\n🏁 🏁 🏁 Server is running on ${server.address}:${server.port}...',
  );*/

  // Listen for server shutdown and close Firebase Admin
  ProcessSignal.sigint.watch().listen((_) async {
    print('\n🏁 🏁 Shutting down server... 🏁 🏁 \n');
    await firebaseAdmin?.close();
    exit(0);
  });

  return server;
}
