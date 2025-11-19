import 'package:pebblex_app/core/dataprovider/api_endpoints.dart';
import 'package:pebblex_app/core/dataprovider/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService.instance;

  //login api call
  Future<Map<String, dynamic>> login({required String body}) async {
    final response = await _apiService.httpPost(
      url: ApiEndpoints.loginApi,
      body: body,
      isWithoutToken: true,
    );
    return response;
  }

  // Register API call
  Future<Map<String, dynamic>> register({required String body}) async {
    final response = await _apiService.httpPost(
      url: ApiEndpoints.registerApi,
      body: body,
      isWithoutToken: true,
    );

    return response;
  }

  // Logout API call
  // Future<void> logout() async {
  //   await _apiService.httpPost(
  //     url: ApiEndpoints.logout,
  //     body: {},
  //     isWithoutToken: false,
  //   );
  // }

  // Get user profile API call
  // Future<Map<String, dynamic>> getUserProfile() async {
  //   final response = await _apiService.httpGet(
  //     url: ApiEndpoints.profile,
  //     isWithoutToken: false,
  //   );

  //   return response;
  // }

  // Refresh token API call
  // Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
  //   final response = await _apiService.httpPost(
  //     url: ApiEndpoints.refreshToken,
  //     body: {'refresh_token': refreshToken},
  //     isWithoutToken: true,
  //   );

  //   return response;
  // }

  // Verify email API call
  // Future<Map<String, dynamic>> verifyEmail({
  //   required String email,
  //   required String code,
  // }) async {
  //   final response = await _apiService.httpPost(
  //     url: ApiEndpoints.verifyEmail,
  //     body: {
  //       'email': email,
  //       'verification_code': code,
  //     },
  //     isWithoutToken: true,
  //   );

  //   return response;
  // }

  // Reset password API call
  // Future<void> resetPassword({
  //   required String email,
  //   required String newPassword,
  //   required String token,
  // }) async {
  //   await _apiService.httpPost(
  //     url: ApiEndpoints.resetPassword,
  //     body: {
  //       'email': email,
  //       'new_password': newPassword,
  //       'reset_token': token,
  //     },
  //     isWithoutToken: true,
  //   );
  // }
}
