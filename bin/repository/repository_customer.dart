import '../customer/entities/newCustomer.dart';
import '../database/database_helper.dart';
import 'package:logging/logging.dart';

final log = Logger('CustomerUseCase');
abstract class IRepositoryCustomer {

  Future<void> addCustomer(NewCustomer newCustomer);
}

class RepositoryCustomer implements IRepositoryCustomer{

  @override
  Future<void> addCustomer(NewCustomer newCustomer) async {
    try {
      final db = DatabaseHelper.database;

      final customerId = await db.insert('customer', {
        'name': newCustomer.customer.name,
        'surname': newCustomer.customer.surname,
        'email': newCustomer.customer.email,
        'document': newCustomer.customer.document,
        'whatsapp': newCustomer.customer.whatsapp,
        'observation': newCustomer.customer.observation,
      });

      await db.insert('address', {
        'customer_id': customerId,
        'cep': newCustomer.address.cep,
        'city': newCustomer.address.city,
        'neighborhood': newCustomer.address.neighborhood,
        'road': newCustomer.address.road,
        'number': newCustomer.address.number,
      });

    } catch (e) {
     log.severe('ERROR: $e');
    }
  }





}