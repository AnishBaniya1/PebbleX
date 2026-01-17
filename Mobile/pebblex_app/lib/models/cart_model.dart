class CartItem {
  final String productId;
  final String supplierId;
  final String name;
  final String category;
  final String image;
  final double price;
  final int stock;
  int quantity;

  CartItem({
    required this.productId,
    required this.supplierId,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.stock,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'supplierId': supplierId,
    'name': name,
    'category': category,
    'image': image,
    'price': price,
    'stock': stock,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'] ?? '',
    supplierId: json['supplierId'] ?? '',
    name: json['name'] ?? '',
    category: json['category'] ?? '',
    image: json['image'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    stock: json['stock'] ?? 0,
    quantity: json['quantity'] ?? 1,
  );

  CartItem copyWith({
    String? productId,
    String? supplierId,
    String? name,
    String? category,
    String? image,
    double? price,
    int? stock,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
    );
  }
}
