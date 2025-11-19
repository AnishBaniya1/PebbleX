class ApiEndpoints {
  static const String storeKey = '';
  static const String _devUrl = 'http://10.0.2.2:5159';
  // static const String _prodUrl = '';
  static const String baseUrl = _devUrl;

  static const String loginApi = '$baseUrl/api/Account/Login';
  static const String registerApi = '$baseUrl/register';
}
