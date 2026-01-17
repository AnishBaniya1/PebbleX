class ApiEndpoints {
  static const String storeKey = '';
  static const String _devUrl = 'http://10.0.2.2:5000';
  // static const String _prodUrl = '';
  static const String baseUrl = _devUrl;

  //User related api
  static const String loginApi = '$baseUrl/api/v1/auth/login';
  static const String registerApi = '$baseUrl/api/v1/auth/register';
  static const String getUserApi = '$baseUrl/api/v1/auth/profile';

  //Product related api
  static const String productApi = '$baseUrl/api/v1/product';
  static const String orderApi = '$baseUrl/api/v1/order';
}
