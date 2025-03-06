class LoginUser {

  LoginUser({ this.email,  this.password,  this.name});


  final String? name;
  final String? email;
  final String? password;


  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

}