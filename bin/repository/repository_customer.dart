import '../customer/entities/customer.dart';
import '../database/database_helper.dart';
import 'package:logging/logging.dart';

final log = Logger('CustomerUseCase');
abstract class IRepositoryCustomer {

  Future<void> addCustomer(Customer customer);

  Future<List<Customer>> listCustomers();

  Future<void> deleteCustomer(int id);
}

class RepositoryCustomer implements IRepositoryCustomer{

  @override
  Future<void> addCustomer(Customer customer) async {
    try {
      final db = DatabaseHelper.database;

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
                SELECT * FROM customer as c
                INNER JOIN address as ad ON
                c.id = ad.customer_id
                       ''';

    final db = DatabaseHelper.database;
    final result = await db.rawQuery(
      query,
    );

    if(result.isEmpty){
      return [];
    }

    List<Customer> list = [];
    for(var row in result){
      list.add(Customer.fromQuery(row));
    }
    return list;


  }catch (e) {
    print('Erro ao listar clientes: $e');
  }

  return [];
}

Future<void> deleteCustomer(int id)async{
    print('cheguei no repositorio ');
    try{
      var args = [];

      args.add(id);



      final db = DatabaseHelper.database;

      await db.rawDelete('DELETE FROM address WHERE customer_id = ?', [id]);

      await db.rawDelete('DELETE FROM customer WHERE id = ?', [id]);

    }catch(e){
      print('Erro ao deletar cliente $e');
    }
}


}