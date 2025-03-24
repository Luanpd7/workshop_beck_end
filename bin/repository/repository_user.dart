import '../database/database_helper.dart';
import '../user/entities/login_user.dart';

abstract class IRepositoryUser {
  Future<void> addUser(User user);

  Future<List<Map<String, dynamic>>> getUsers();

  Future<User?> findUser(String email, String password);
}

class RepositoryUser implements IRepositoryUser {
  @override
  Future<void> addUser(User user) async {
    try {
      print('user ${user.toString()}');

      final db = DatabaseHelper.database;

      await db.insert('usuarios', {
        'nome': user.name,
        'email': user.email,
        'password': user.password,
      });
    } catch (e) {
      print('Erro ao inserir usuário: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = DatabaseHelper.database;
    return await db.query('usuarios');
  }

  @override
  Future<User?> findUser(String email, String password) async {
    try {
      var query = ''' select 
           id,
           nome, 
           email 
           from usuarios 
           where email = ? AND password = ?
           ''';

      final db = DatabaseHelper.database;
      final result = await db.rawQuery(
        query,
        [email, password],
      );

      if (result.isNotEmpty) {
        return User.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('Erro ao inserir usuário: $e');
    }
    return null;
  }
}
