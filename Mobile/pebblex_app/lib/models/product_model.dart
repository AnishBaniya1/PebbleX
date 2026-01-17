class ProductModel {
  ProductModel({
    required this.success,
    required this.count,
    required this.products,
  });

  final bool? success;
  final int? count;
  final List<Product> products;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      success: json["success"],
      count: json["count"],
      products: json["products"] == null
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "products": products.map((x) => x?.toJson()).toList(),
  };
}

class Product {
  Product({
    required this.image,
    required this.id,
    required this.supplier,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.sold,
    required this.category,
    required this.sku,
    required this.images,
    required this.rating,
    required this.status,
    required this.lowStockThreshold,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final dynamic image;
  final String? id;
  final Supplier? supplier;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final int? sold;
  final String? category;
  final String? sku;
  final List<String> images;
  final int? rating;
  final String? status;
  final int? lowStockThreshold;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json["image"],
      id: json["_id"],
      supplier: json["supplier"] == null
          ? null
          : Supplier.fromJson(json["supplier"]),
      name: json["name"],
      description: json["description"],
      price: json["price"],
      stock: json["stock"],
      sold: json["sold"],
      category: json["category"],
      sku: json["sku"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      rating: json["rating"],
      status: json["status"],
      lowStockThreshold: json["lowStockThreshold"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "image": image,
    "_id": id,
    "supplier": supplier?.toJson(),
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "sold": sold,
    "category": category,
    "sku": sku,
    "images": images.map((x) => x).toList(),
    "rating": rating,
    "status": status,
    "lowStockThreshold": lowStockThreshold,
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
