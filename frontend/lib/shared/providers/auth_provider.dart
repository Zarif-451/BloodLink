import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _token;
  String? _userID;
  String? _role;
  String? _fullName;
  String? _email;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null && !JwtDecoder.isExpired(_token!);
  String? get token => _token;
  String? get userID => _userID;
  String? get role => _role;
  String? get fullName => _fullName;
  String? get email => _email;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    _token = await _secureStorage.read(key: 'access_token');
    if (_token != null && !JwtDecoder.isExpired(_token!)) {
      final payload = JwtDecoder.decode(_token!);
      _userID = payload['user_ID'] as String?;
      _role = payload['role'] as String?;
      notifyListeners();
    } else {
      await _secureStorage.delete(key: 'access_token');
      _token = null;
    }
  }

  Future<void> login(String token, Map<String, dynamic> profile) async {
    _token = token;
    _userID = profile['user_ID'] as String?;
    _role = profile['role'] as String?;
    _fullName = profile['full_name'] as String?;
    _email = profile['email'] as String?;
    await _secureStorage.write(key: 'access_token', value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _role = null;
    _fullName = null;
    _email = null;
    await _secureStorage.delete(key: 'access_token');
    notifyListeners();
  }
}