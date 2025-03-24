/*
import 'package:dart_frog/dart_frog.dart';

import '../utils/auth_helper.dart';

Handler authMiddleware(Handler handler) {
  return (context) async {
    final token =
        context.request.headers['Authorization']?.replaceFirst('Bearer ', '');
    if (token == null) {
      return Response(statusCode: 401, body: 'Unauthorized');
    }

    final uid = await AuthHelper.verifyIdToken(token);
    if (uid == null) {
      return Response(statusCode: 401, body: 'Invalid token');
    }

    return handler(context);
  };
}
*/
