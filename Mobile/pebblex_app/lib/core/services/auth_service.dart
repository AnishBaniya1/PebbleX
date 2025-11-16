import 'package:pebblex_app/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();

  Future<void> login({required String body}) async {
    try {
      final response = await _repository.login(body: body);
      return response;
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
