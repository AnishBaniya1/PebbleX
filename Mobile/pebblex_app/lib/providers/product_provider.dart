import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pebblex_app/core/services/product_service.dart';
import 'package:pebblex_app/models/orderproduct_model.dart';
import 'package:pebblex_app/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = []; // ✅ Changed to List<Product>
  List<Product> get products => _products;

  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> availableproduct() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _productService.availableproduct();

      final productModel = ProductModel.fromJson(response);
      _products = productModel.products;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderproductModel?> orderproduct({
    required String supplierId,
    required List<Map<String, dynamic>> items,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final body = jsonEncode({'supplier': supplierId, 'items': items});

      final response = await _productService.orderproduct(body: body);
      OrderproductModel orderModel = OrderproductModel.fromJson(response);

      _isLoading = false;
      notifyListeners();
      return orderModel;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
