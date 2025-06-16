import '../database/database_helper.dart';
import '../user/entities/login_user.dart';

abstract class IRepositoryUser {
  Future<void> addUser(User user);
  Future<List<Map<String, dynamic>>> getUsers();
  Future<User?> findUser(String name, String password);
}

class RepositoryUser implements IRepositoryUser {
  @override
  Future<void> addUser(User user) async {
    try {
      print('user ------------------ ${user.toString()}');

      final db = await DatabaseHelper.getDatabase();

      await db.insert('usuarios', {
        'nome': user.name ?? '',
        'email': user.email ?? '',
        'password': user.password ?? '',
      });
    } catch (e) {
      print('Erro ao inserir usuário: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.getDatabase();
    return await db.query('usuarios');
  }

  @override
  Future<User?> findUser(String name, String password) async {
    try {
      final query = '''
        SELECT id, nome, email
        FROM usuarios 
        WHERE nome = ? AND password = ?
      ''';

      final db = await DatabaseHelper.getDatabase();
      final result = await db.rawQuery(query, [name, password]);

      if (result.isNotEmpty) {
        return User.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }
}
