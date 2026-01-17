class ProfileModel {
  ProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.phone,
    required this.isActive,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? address;
  final int? phone;
  final bool? isActive;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      address: json["address"],
      phone: json["phone"],
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
    "address": address,
    "phone": phone,
    "isActive": isActive,
  };
}
