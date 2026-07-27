import '../core/api_client.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getProfile() async {
    throw UnimplementedError();
  }
}