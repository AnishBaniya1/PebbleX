class LoginModel {
  final String? email;
  final String? password;

  LoginModel({this.email, this.password});

  // Convert JSON to LoginModel
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(email: json['email'], password: json['password']);
  }

  // Convert LoginModel to JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  // Create copy with updated fields
  LoginModel copyWith({String? email, String? password}) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
