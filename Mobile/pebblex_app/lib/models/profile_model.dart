class ProfileModel {
  ProfileModel({required this.message, required this.user});

  final String? message;
  final User? user;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      message: json["message"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {"message": message, "user": user?.toJson()};
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final int? phone;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      phone: json["phone"],
      address: json["address"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
    "phone": phone,
    "address": address,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
