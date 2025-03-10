class User {

  User({ this.email,  this.password,  this.name});

  final String? name;
  final String? email;
  final String? password;


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password}';
  }
}