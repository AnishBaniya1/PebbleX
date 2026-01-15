class LoginResponseModel {
  LoginResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    required this.message,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? token;
  final String? message;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      token: json["token"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
    "token": token,
    "message": message,
  };
}
