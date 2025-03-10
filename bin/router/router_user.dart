import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../user/entities/login_user.dart';
import '../user/use_case/use_case_user.dart';


class UserRouter {
  Router get router {
    final router = Router();


    router.post('/add_usuario', (Request request) async {
      try {


        print('to aquiiiiiiiiiiiiiii');
        final body = await request.readAsString();
        final data = jsonDecode(body);

        final user = User.fromJson(data);
        await UseCaseUser.addUser(user);

        return Response.ok(jsonEncode({'message': 'Usuário cadastrado com sucesso'}),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao processar requisição'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.post('/login', (Request request) async {
      try {


        print('to aquiiiiiiiiiiiiiii');
        final body = await request.readAsString();
        final data = jsonDecode(body);

        final email = data['email'];
        final password = data['nome'];

        final user = await UseCaseUser.findUser(email, password);
        if (user != null) {
          return Response.ok(jsonEncode({'message': 'Login bem-sucedido'}),
              headers: {'Content-Type': 'application/json'});
        } else {
          return Response.forbidden(jsonEncode({'message': 'Credenciais inválidas'}),
              headers: {'Content-Type': 'application/json'});
        }
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Erro no servidor'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    return router;
  }
}
