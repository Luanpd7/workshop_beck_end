import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../customer/entities/customer.dart';
import '../domain/use_case_customer.dart';
import '../repository/repository_customer.dart';
import '../repository/repository_user.dart';
import '../user/entities/login_user.dart';
import '../domain/use_case_user.dart';

class UserRouter {
  Router get router {
    final router = Router();

    router.get('/listCustomers', (Request request) async {
      try {

        final repository = RepositoryCustomer();
        final useCaseCustomer = UseCaseCustomer(repository);

        final list = await useCaseCustomer.listCustomers();

        final jsonResponse = jsonEncode(list.map((customer) => customer.toJson()).toList());
        return Response.ok(
          jsonResponse,
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e, stacktrace) {
        print("Erro ao listar clientes: $e \n $stacktrace");

        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao listar clientes'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });



    router.get('/get_servidor', (Request request) async {
      try {
        return Response.ok(
            jsonEncode({'message': 'Servidor rodando'}),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao rodar servidor'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.post('/add_customer', (Request request) async {
      try {
        final repository = RepositoryCustomer();
        final useCaseCustomer = UseCaseCustomer(repository);

        final body = await request.readAsString();
        final data = jsonDecode(body);

        final newCustomer = Customer.fromJson(data);

        await useCaseCustomer.addCustomer(newCustomer);

        return Response.ok(
            jsonEncode({'message': 'Usuário cadastrado com sucesso'}),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao processar requisição'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.post('/add_usuario', (Request request) async {
      try {
        final repository = RepositoryUser();
        final useCaseUser = UseCaseUser(repository);

        final body = await request.readAsString();
        final data = jsonDecode(body);

        final user = User.fromJson(data);
        await useCaseUser.addUser(user);

        return Response.ok(
            jsonEncode({'message': 'Usuário cadastrado com sucesso para o gostoso do valdi'}),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao processar requisição do gostoso do valdi'}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.delete('/delete_customer', (Request request) async {
      try {
        final repository = RepositoryCustomer();
        final useCaseCustomer = UseCaseCustomer(repository);

        final body = await request.readAsString();

        final data = jsonDecode(body);
        final id = data['id'];


        await useCaseCustomer.deleteCustomer(id);

        return Response.ok(
          jsonEncode({'success': true}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        print('Erro ao deletar cliente: $e');
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao deletar cliente'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }
    );

    router.post('/login', (Request request) async {
      try {
        final repository = RepositoryUser();
        final useCaseUser = UseCaseUser(repository);

        final body = await request.readAsString();
        final data = jsonDecode(body);

        final email = data['email'];
        final password = data['password'];

        final user = await useCaseUser.findUser(email, password);



        if (user != null) {
          return Response.ok(
            jsonEncode({
              'user': user.toJson()
            }),
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return Response.forbidden(
            jsonEncode({'message': 'Credenciais inválidas'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro no servidor: $e'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    return router;
  }
}
