class SearchModel {
  SearchModel({required this.count, required this.products});

  final int? count;
  final List<Product> products;

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      count: json["count"],
      products: json["products"] == null
          ? []
          : List<Product>.from(
              json["products"]!.map((x) => Product.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "count": count,
    "products": products.map((x) => x?.toJson()).toList(),
  };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.images,
  });

  final String? id;
  final String? name;
  final int? price;
  final int? stock;
  final String? category;
  final List<String> images;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
      stock: json["stock"],
      category: json["category"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
    "stock": stock,
    "category": category,
    "images": images.map((x) => x).toList(),
  };
}
