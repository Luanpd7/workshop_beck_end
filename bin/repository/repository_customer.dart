import '../customer/entities/address.dart';
import '../customer/entities/customer.dart';
import '../database/database_helper.dart';
import 'package:logging/logging.dart';

final log = Logger('CustomerUseCase');

abstract class IRepositoryCustomer {

  Future<void> addCustomer(Customer customer);

  Future<List<Customer>> listCustomers();

  Future<void> deleteCustomer(int id);
}

class RepositoryCustomer implements IRepositoryCustomer {

  @override
  Future<void> addCustomer(Customer customer) async {
    try {
      final db = await DatabaseHelper.getDatabase();

      final customerId = await db.insert('customer', {
        'name': customer.name,
        'surname': customer.surname,
        'email': customer.email,
        'document': customer.document,
        'whatsapp': customer.whatsapp,
        'observation': customer.observation,
      });

      await db.insert('address', {
        'customer_id': customerId,
        'cep': customer.address?.cep,
        'city': customer.address?.city,
        'neighborhood': customer.address?.neighborhood,
        'road': customer.address?.road,
        'number': customer.address?.number,
      });
    } catch (e) {
      log.severe('ERROR: $e');
    }
  }


  @override
  Future<List<Customer>> listCustomers() async {
    try {
      String query = '''
    SELECT 
        c.id as c_id,
        c.name as c_name,
        c.surname as c_surname, 
        c.email as c_email, 
        c.document as c_document, 
        c.observation as c_observation,
        c.whatsapp as c_whatsapp,
        ad.road as ad_road,
        ad.cep as ad_cep,
        ad.number as ad_number,
        ad.neighborhood as ad_neighborhood,
        ad.city as ad_city
    FROM customer as c
    INNER JOIN address as ad ON c.id = ad.customer_id
''';

      final db = await DatabaseHelper.getDatabase();
      final result = await db.rawQuery(
        query,
      );

      if (result.isEmpty) {
        return [];
      }

      List<Customer> list = [];
      for (var row in result) {
        final customer =
        Customer(
          id: row['c_id'] as int,
          name: row['c_name'] as String,
          surname: row['c_surname'] as String,
          document: row['c_document'] as String,
          email: row['c_email'] as String,
          observation: row['c_observation'] as String,
          whatsapp: row['c_whatsapp'] as String,
          address: Address(
            city: row['ad_city'] as String,
            cep: row['ad_cep'] as String,
            road: row['ad_road'] as String,
            number: row['ad_number'] as String,
            neighborhood: row['ad_neighborhood'] as String,
        )
        );
        list.add(customer);
      }
      return list;
    } catch (e) {
      log.severe('ERROR: $e');
    }

    return [];
  }

  @override
  Future<void> deleteCustomer(int id) async {
    try {
      var args = [];
      args.add(id);
      final db = await DatabaseHelper.getDatabase();

      await db.rawDelete('DELETE FROM address WHERE customer_id = ?', [id]);

      await db.rawDelete('DELETE FROM customer WHERE id = ?', [id]);
    } catch (e) {
      log.severe('ERROR: $e');
    }
  }


}