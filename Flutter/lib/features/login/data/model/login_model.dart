class LoginModel {
  final String password;
  final String? email;
  final String? phone;

  LoginModel({required this.password, this.email, this.phone});

  Map<String, dynamic> toJson() {
    return {'password': password, 'email': email, 'phone': phone};
  }
}
