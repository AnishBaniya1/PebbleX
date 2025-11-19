import 'package:pebblex_app/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();

  Future<Map<String, dynamic>> login({required String body}) async {
    final response = await _repository.login(body: body);
    return response;
  }

  Future<Map<String, dynamic>> register({required String body}) async {
    return await _repository.register(body: body);
  }
}
