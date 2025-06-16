import 'address.dart';

/// class responsible for customer info
class Customer {
  Customer({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.whatsapp,
    this.document,
    this.observation,
    this.address,
  });

  /// id of customer
  final int? id;

  /// name of customer
  final String? name;

  /// surname of customer
  final String? surname;

  /// whatsapp of customer
  final String? whatsapp;

  /// email of? customer
  final String? email;

  /// document of customer
  final String? document;

  /// observation of customer
  final String? observation;

  /// address of customer
  final Address? address;

  factory Customer.fromJson(Map<String, dynamic> json) {
    final data = json['Customer'];
    return Customer(
      id: data['id'],
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      email: data['email'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
      document: data['document'] ?? '',
      observation: data['observation'] ?? '',
      address:
          data['address'] != null ? Address.fromJson(data['address']) : null,
    );
  }

  factory Customer.fromQuery(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      document: json['document'] ?? '',
      observation: json['observation'] ?? '',
      address: Address(
        cep: json['cep'],
        city: json['city'],
        neighborhood: json['neighborhood'],
        road: json['road'],
        number: json['number'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'surname': surname ?? '',
      'email': email ?? '',
      'whatsapp': whatsapp ?? '',
      'document': document ?? '',
      'observation': observation ?? '',
      'address': address?.toJson() ?? {},
    };
  }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, surname: $surname, whatsapp: $whatsapp, email: $email, document: $document, observation: $observation, address: $address}';
  }
}
