import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pebblex_app/core/services/product_service.dart';
import 'package:pebblex_app/models/orderhistory_model.dart' as history;
import 'package:pebblex_app/models/orderproduct_model.dart';
import 'package:pebblex_app/models/product_model.dart';
import 'package:pebblex_app/models/search_model.dart' as search;

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = []; // ✅ Changed to List<Product>
  List<Product> get products => _products;
  List<history.Order> _orders = [];
  List<history.Order> get orders => _orders;
  List<search.Product> _searchResults = []; // ✅ Added search results list
  List<search.Product> get searchResults => _searchResults;

  int _orderCount = 0;
  int get orderCount => _orderCount;
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

  Future<void> orderhistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _productService.orderhistory();

      history.OrderhistoryModel historyModel =
          history.OrderhistoryModel.fromJson(response);

      _orders = historyModel.orders;
      _orderCount = historyModel.count ?? 0;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel a booking
  Future<void> cancelorder(String orderId) async {
    try {
      await _productService.cancelorder(orderId: orderId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> searchproduct({required String productname}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _productService.searchproduct(search: productname);

      search.SearchModel searchModel = search.SearchModel.fromJson(response);

      _searchResults =
          searchModel.products; // ✅ Fixed: Changed from 'data' to 'products'

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
