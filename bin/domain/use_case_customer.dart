import '../customer/entities/newCustomer.dart';
import '../repository/repository_customer.dart';

class UseCaseCustomer {
  final IRepositoryCustomer repository;

  UseCaseCustomer(this.repository);

  Future<void> addCustomer(NewCustomer newCustomer)
   => repository.addCustomer(newCustomer);
}