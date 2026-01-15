import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pebblex_app/core/services/auth_service.dart';
import 'package:pebblex_app/core/services/secure_storage.dart';
import 'package:pebblex_app/models/loginresponse_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = SecureStorageService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final body = jsonEncode({'email': email, 'password': password});

      final response = await _authService.login(body: body);

      LoginResponseModel loginModel = LoginResponseModel.fromJson(response);
      await _storageService.setValue('authtoken', loginModel.token!);
      // await _storageService.setValue('role', loginModel.role!);
      await _storageService.setValue('islogin', 'true');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? role,
    required int phone,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final body = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
      });

      await _authService.register(body: body);

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
