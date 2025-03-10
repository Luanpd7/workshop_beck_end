import '../../repository/repository_user.dart';
import '../../user/entities/login_user.dart';

class UseCaseUser {
  static Future<void> addUser(User user) async => RepositoryUser.addUser(user);

  static Future<List<Map<String, dynamic>>> getUser(User user) async =>
      RepositoryUser.getUsers();

  static Future<User?> findUser(String email, String password) async =>
      RepositoryUser.findUser(email, password);
}
