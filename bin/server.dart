// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/api/index.dart' as api_index;
import '../routes/api/shifts/index.dart' as api_shifts_index;
import '../routes/api/shifts/[id]/index.dart' as api_shifts_$id_index;
import '../routes/api/shifts/[id]/clockout.dart' as api_shifts_$id_clockout;
import '../routes/api/shifts/[id]/clockin.dart' as api_shifts_$id_clockin;
import '../routes/api/requests/index.dart' as api_requests_index;
import '../routes/api/requests/[id]/match.dart' as api_requests_$id_match;
import '../routes/api/requests/[id]/index.dart' as api_requests_$id_index;
import '../routes/api/requests/[id]/float.dart' as api_requests_$id_float;
import '../routes/api/requests/[id]/accept.dart' as api_requests_$id_accept;
import '../routes/api/reports/index.dart' as api_reports_index;
import '../routes/api/reports/[id].dart' as api_reports_$id;
import '../routes/api/notifications/index.dart' as api_notifications_index;
import '../routes/api/notifications/[id]/read.dart' as api_notifications_$id_read;
import '../routes/api/clients/index.dart' as api_clients_index;
import '../routes/api/clients/[id].dart' as api_clients_$id;
import '../routes/api/carehomes/index.dart' as api_carehomes_index;
import '../routes/api/carehomes/[id].dart' as api_carehomes_$id;
import '../routes/api/caregivers/index.dart' as api_caregivers_index;
import '../routes/api/caregivers/[id].dart' as api_caregivers_$id;
import '../routes/api/activations/index.dart' as api_activations_index;
import '../routes/admin/index.dart' as admin_index;
import '../routes/admin/[id].dart' as admin_$id;

import '../routes/api/_middleware.dart' as api_middleware;
import '../routes/api/shifts/_middleware.dart' as api_shifts_middleware;
import '../routes/api/requests/_middleware.dart' as api_requests_middleware;
import '../routes/api/clients/_middleware.dart' as api_clients_middleware;
import '../routes/api/carehomes/_middleware.dart' as api_carehomes_middleware;
import '../routes/api/caregivers/_middleware.dart' as api_caregivers_middleware;
import '../routes/api/activations/_middleware.dart' as api_activations_middleware;
import '../routes/admin/_middleware.dart' as admin_middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  await entrypoint.init(address, port);
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await entrypoint.run(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/admin', (context) => buildAdminHandler()(context))
    ..mount('/api/activations', (context) => buildApiActivationsHandler()(context))
    ..mount('/api/caregivers', (context) => buildApiCaregiversHandler()(context))
    ..mount('/api/carehomes', (context) => buildApiCarehomesHandler()(context))
    ..mount('/api/clients', (context) => buildApiClientsHandler()(context))
    ..mount('/api/notifications/<id>', (context,id,) => buildApiNotifications$idHandler(id,)(context))
    ..mount('/api/notifications', (context) => buildApiNotificationsHandler()(context))
    ..mount('/api/reports', (context) => buildApiReportsHandler()(context))
    ..mount('/api/requests/<id>', (context,id,) => buildApiRequests$idHandler(id,)(context))
    ..mount('/api/requests', (context) => buildApiRequestsHandler()(context))
    ..mount('/api/shifts/<id>', (context,id,) => buildApiShifts$idHandler(id,)(context))
    ..mount('/api/shifts', (context) => buildApiShiftsHandler()(context))
    ..mount('/api', (context) => buildApiHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildAdminHandler() {
  final pipeline = const Pipeline().addMiddleware(admin_middleware.middleware);
  final router = Router()
    ..all('/', (context) => admin_index.onRequest(context,))..all('/<id>', (context,id,) => admin_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiActivationsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_activations_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_activations_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiCaregiversHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_caregivers_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_caregivers_index.onRequest(context,))..all('/<id>', (context,id,) => api_caregivers_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiCarehomesHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_carehomes_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_carehomes_index.onRequest(context,))..all('/<id>', (context,id,) => api_carehomes_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiClientsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_clients_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_clients_index.onRequest(context,))..all('/<id>', (context,id,) => api_clients_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiNotifications$idHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware);
  final router = Router()
    ..all('/read', (context) => api_notifications_$id_read.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiNotificationsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_notifications_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiReportsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_reports_index.onRequest(context,))..all('/<id>', (context,id,) => api_reports_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiRequests$idHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_requests_middleware.middleware);
  final router = Router()
    ..all('/match', (context) => api_requests_$id_match.onRequest(context,id,))..all('/', (context) => api_requests_$id_index.onRequest(context,id,))..all('/float', (context) => api_requests_$id_float.onRequest(context,id,))..all('/accept', (context) => api_requests_$id_accept.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiRequestsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_requests_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_requests_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiShifts$idHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_shifts_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_shifts_$id_index.onRequest(context,id,))..all('/clockout', (context) => api_shifts_$id_clockout.onRequest(context,id,))..all('/clockin', (context) => api_shifts_$id_clockin.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiShiftsHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware).addMiddleware(api_shifts_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_shifts_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiHandler() {
  final pipeline = const Pipeline().addMiddleware(api_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_index.onRequest(context,));
  return pipeline.addHandler(router);
}

