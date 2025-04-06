import '../repository/repository_user.dart';
import '../user/entities/login_user.dart';

class UseCaseUser {
  UseCaseUser(this.repository);

  final IRepositoryUser repository;

  Future<void> addUser(User user) async => repository.addUser(user);

  Future<List<Map<String, dynamic>>> getUser(User user) async =>
      repository.getUsers();

  Future<User?> findUser(String email, String password) async =>
      repository.findUser(email, password);
}
