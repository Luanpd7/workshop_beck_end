import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;


import 'bin/user/entities/login_user.dart';

Future<Response> handler(Request request) async {
  if (request.method == 'POST' && request.url.path == 'add_usuario') {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final user = User.fromJson(data);

      print('Usuário recebido: Name=${user.name}, Email=${user.email}, Password=${user.password}');

      if (user.email == 'Luan' && user.password == '123') {
        print('acessou !');
        return Response.ok(jsonEncode({'message': 'Acessado'}),
            headers: {'Content-Type': 'application/json'});

      } else {
        print(' não acessou acessou !');
        return Response.forbidden(jsonEncode({'message': 'Não acessou'}),
            headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      print('Erro: $e');
      return Response.internalServerError(body: jsonEncode({'erro': 'Erro no servidor'}),
          headers: {'Content-Type': 'application/json'});
    }
  }

  return Response.notFound(jsonEncode({'erro': 'Rota não encontrada'}),
      headers: {'Content-Type': 'application/json'});
}

void main() async {
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Servidor rodando em http://0.0.0.0:8080');
}
