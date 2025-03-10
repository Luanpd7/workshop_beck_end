import '../database/database_helper.dart';
import '../user/entities/login_user.dart';

class RepositoryUser {

  static Future<void> addUser(User user) async {
     try {
       print('to aqui2 !!!!!!!!!!!!!');
       print('user ${user.toString()}');

       final db = DatabaseHelper.database;

       print('Inserindo dados no banco...');

       await db.insert('usuarios', {
         'nome': user.name,
         'email': user.email,
         'password': user.password,
       });

       print('Usuário adicionado com sucesso! ');
     } catch (e) {
       print('Erro ao inserir usuário: $e');
     }
   }


   static Future<List<Map<String, dynamic>>> getUsers() async {
     print('Chegou no repositório -> addUser');
    final db = DatabaseHelper.database;
    return await db.query('usuarios');
  }

   static Future<User?> findUser(String email, String password) async {
     try {
       print('Chegou no repositório -> addUser');
       final db = DatabaseHelper.database;
       final result = await db.query(
         'usuarios',
         where: 'email = ? AND password = ?',
         whereArgs: [email, password],
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
