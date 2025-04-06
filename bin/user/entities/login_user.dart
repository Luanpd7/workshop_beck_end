class User {

  User({this.id, this.email,  this.password,  this.name});

  final int? id;
  final String? name;
  final String? email;
  final String? password;


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nome'],
      email: json['email'],
      password: json['password'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password}';
  }
}