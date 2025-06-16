import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'bin/database/database_helper.dart';
import 'bin/router/router_user.dart';


void main() async {
  await DatabaseHelper.getDatabase();
  final userRouter = UserRouter().router;

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(userRouter);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('Servidor rodando em http://localhost:8080');
}
