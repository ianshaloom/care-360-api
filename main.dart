// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_frog/dart_frog.dart';

// Global variable to store the Firebase Admin instance
FirebaseAdminApp? firebaseAdmin;

Future<void> init(InternetAddress ip, int port) async {
  print('\n.\n.\n.\n 🏁 Initializing Firebase Admin SDK... 🏁');

  // Initialize Firebase Admin SDK
  firebaseAdmin = FirebaseAdminApp.initializeApp(
    'care360-26413',
    Credential.fromServiceAccount(
      File('service-account.json'),
    ),
  );

  print(
      '\n.\n.\n.\n 🏁 🏁 Firebase Admin SDK initialized successfully! 🏁 🏁 \n.\n.\n.\n');
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  // Start the server
  final server = await serve(handler, ip, port);

  print(
      '\n.\n.\n.\n 🏁 🏁 🏁 Server is running on ${server.address}:${server.port} 🏁 🏁 🏁 \n.\n.\n.\n');

  // Listen for server shutdown and close Firebase Admin
  ProcessSignal.sigint.watch().listen((_) async {
    print('\n.\n.\n.\n 🏁 🏁 Shutting down server... 🏁 🏁 \n.\n.\n.\n');
    await firebaseAdmin?.close();
    exit(0);
  });

  return server;
}
