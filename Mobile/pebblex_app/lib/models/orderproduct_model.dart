class OrderproductModel {
  OrderproductModel({required this.order, required this.message});

  final Order? order;
  final String? message;

  factory OrderproductModel.fromJson(Map<String, dynamic> json) {
    return OrderproductModel(
      order: json["order"] == null ? null : Order.fromJson(json["order"]),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "order": order?.toJson(),
    "message": message,
  };
}

class Order {
  Order({
    required this.vendor,
    required this.supplier,
    required this.items,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? vendor;
  final String? supplier;
  final List<Item> items;
  final String? status;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      vendor: json["vendor"],
      supplier: json["supplier"],
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      status: json["status"],
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "vendor": vendor,
    "supplier": supplier,
    "items": items.map((x) => x?.toJson()).toList(),
    "status": status,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Item {
  Item({required this.product, required this.quantity, required this.id});

  final String? product;
  final int? quantity;
  final String? id;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      product: json["product"],
      quantity: json["quantity"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "product": product,
    "quantity": quantity,
    "_id": id,
  };
}
