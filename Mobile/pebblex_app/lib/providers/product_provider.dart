import 'package:flutter/material.dart';
import 'package:pebblex_app/core/services/product_service.dart';
import 'package:pebblex_app/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = []; // ✅ Typed list
  List<ProductModel> get products => _products;

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
      _products = response
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }
}
