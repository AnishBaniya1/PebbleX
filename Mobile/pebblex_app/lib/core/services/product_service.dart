import 'package:pebblex_app/core/dataprovider/api_endpoints.dart';
import 'package:pebblex_app/core/dataprovider/api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService.instance;

  // Get Available products to vendor
  Future<List<dynamic>> availableproduct() async {
    final response = await _apiService.httpGet(
      url: ApiEndpoints.productApi,
      isWithoutToken: false,
    );

    return response;
  }
}
