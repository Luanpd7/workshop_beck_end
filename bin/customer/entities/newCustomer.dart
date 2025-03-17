import 'address.dart';
import 'customer.dart';

class NewCustomer {
  NewCustomer({required this.customer, required this.address});

  final Customer customer;
  final Address address;

  factory NewCustomer.fromJson(Map<String, dynamic> json) {
    return NewCustomer(
      customer: Customer.fromJson(json['Customer']),
      address: Address.fromJson(json['Address']),
    );
  }
}

