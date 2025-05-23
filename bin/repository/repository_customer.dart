import '../customer/entities/customer.dart';
import '../database/database_helper.dart';
import 'package:logging/logging.dart';

final log = Logger('CustomerUseCase');
abstract class IRepositoryCustomer {

  Future<void> addCustomer(Customer customer);

  Future<List<Customer>> listCustomers();
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

Future<List<Customer>> listCustomers() async {
  try {
    String query = '''
                SELECT * FROM CUSTOMER AS C
                INNER JOIN ADDRESS AS AD
                C.id ON AD AD.customer_id
                       ''';

    final db = DatabaseHelper.database;
    final result = await db.rawQuery(
      query,
    );

    if(result.isEmpty){
      return [];
    }

    for(var row in result){

    }

    return [];


  }catch (e) {
    print('Erro ao listar clientes: $e');
  }

  return [];
}



}