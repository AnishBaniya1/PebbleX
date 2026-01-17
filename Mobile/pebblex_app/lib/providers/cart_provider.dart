import 'package:flutter/material.dart';
import 'package:pebblex_app/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  int get totalQuantity {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  void addItem({
    required String productId,
    required String supplierId,
    required String name,
    required String category,
    required String image,
    required double price,
    required int stock,
  }) {
    if (_items.containsKey(productId)) {
      // Update quantity if item already exists
      _items.update(
        productId,
        (existingItem) =>
            existingItem.copyWith(quantity: existingItem.quantity + 1),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          productId: productId,
          supplierId: supplierId,
          name: name,
          category: category,
          image: image,
          price: price,
          stock: stock,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (existingItem) => existingItem.copyWith(quantity: quantity),
        );
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      if (item.quantity < item.stock) {
        _items.update(
          productId,
          (existingItem) =>
              existingItem.copyWith(quantity: existingItem.quantity + 1),
        );
        notifyListeners();
      }
    }
  }

  void decrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final item = _items[productId]!;
      if (item.quantity > 1) {
        _items.update(
          productId,
          (existingItem) =>
              existingItem.copyWith(quantity: existingItem.quantity - 1),
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  CartItem? getItem(String productId) {
    return _items[productId];
  }
}
