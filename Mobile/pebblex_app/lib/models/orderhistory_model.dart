class OrderhistoryModel {
  OrderhistoryModel({required this.count, required this.orders});

  final int? count;
  final List<Order> orders;

  factory OrderhistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderhistoryModel(
      count: json["count"],
      orders: json["orders"] == null
          ? []
          : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "count": count,
    "orders": orders.map((x) => x?.toJson()).toList(),
  };
}

class Order {
  Order({
    required this.id,
    required this.vendor,
    required this.supplier,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? vendor;
  final Supplier? supplier;
  final List<Item> items;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["_id"],
      vendor: json["vendor"],
      supplier: json["supplier"] == null
          ? null
          : Supplier.fromJson(json["supplier"]),
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "vendor": vendor,
    "supplier": supplier?.toJson(),
    "items": items.map((x) => x?.toJson()).toList(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Item {
  Item({required this.product, required this.quantity, required this.id});

  final Product? product;
  final num? quantity;
  final String? id;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      product: json["product"] == null
          ? null
          : Product.fromJson(json["product"]),
      quantity: json["quantity"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "quantity": quantity,
    "_id": id,
  };
}

class Product {
  Product({required this.id, required this.name, required this.price});

  final String? id;
  final String? name;
  final num? price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json["_id"], name: json["name"], price: json["price"]);
  }

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "price": price};
}

class Supplier {
  Supplier({required this.id, required this.name, required this.email});

  final String? id;
  final String? name;
  final String? email;

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json["_id"], name: json["name"], email: json["email"]);
  }

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "email": email};
}
