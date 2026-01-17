class ApiEndpoints {
  static const String storeKey = '';
  static const String _devUrl = 'http://10.0.2.2:5000';
  // static const String _prodUrl = '';
  static const String baseUrl = _devUrl;

  //User related api
  static const String loginApi = '$baseUrl/api/v1/auth/login';
  static const String registerApi = '$baseUrl/api/v1/auth/register';
  static const String getUserApi = '$baseUrl/api/v1/auth/profile';
  static const String changePasswordApi =
      '$baseUrl/api/v1/auth/update-my-password';

  //Product related api
  static const String productApi = '$baseUrl/api/v1/product';
  static const String orderApi = '$baseUrl/api/v1/order';
  static const String orderHistoryApi = '$baseUrl/api/v1/order/vendor';
  static String cancelOrderApi(String orderId) =>
      '$baseUrl/api/v1/order/$orderId/cancel';
  static String searchProductApi(String search) =>
      '$productApi/search?query=${Uri.encodeComponent(search)}';
}
