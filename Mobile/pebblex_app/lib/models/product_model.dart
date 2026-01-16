class ProductModel {
  ProductModel({
    required this.id,
    required this.supplier,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.sold,
    required this.category,
    required this.sku,
    required this.image,
    required this.rating,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final Supplier? supplier;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final int? sold;
  final String? category;
  final String? sku;
  final String? image;
  final double? rating;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      supplier: json["supplier"] == null
          ? null
          : Supplier.fromJson(json["supplier"]),
      name: json["name"],
      description: json["description"],
      price: (json["price"] as num?)
          ?.toDouble(), // ✅ Fix: Convert num to double
      stock: json["stock"],
      sold: json["sold"],
      category: json["category"],
      sku: json["sku"],
      image: json["image"],
      rating: (json["rating"] as num?)
          ?.toDouble(), // ✅ Fix: Convert num to double
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "supplier": supplier?.toJson(),
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "sold": sold,
    "category": category,
    "sku": sku,
    "image": image,
    "rating": rating,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Supplier {
  Supplier({required this.id, required this.name});

  final String? id;
  final String? name;

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json["_id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"_id": id, "name": name};
}
