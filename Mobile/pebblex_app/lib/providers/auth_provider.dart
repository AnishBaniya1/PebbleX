import 'dart:convert';
import 'dart:developer';

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
      log(jsonEncode(response));

      LoginResponseModel loginModel = loginResponseModelFromJson(
        jsonEncode(response),
      );
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
