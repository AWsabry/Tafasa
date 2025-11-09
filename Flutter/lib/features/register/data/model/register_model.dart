class RegisterModel {
  final String username;
  final int age;
  final String password;
  final String email;
  final String phoneNumber;

  RegisterModel({
    required this.username,
    required this.age,
    required this.password,
    required this.phoneNumber,
    required this.email,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json['username'] as String,
      age: json['email'] as int,
      password: json['password'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json["email"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'age': age,
      'password': password,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}
