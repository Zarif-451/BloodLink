import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';

  static int get connectTimeout =>
      int.tryParse(dotenv.env['API_CONNECT_TIMEOUT'] ?? '10') ?? 10;

  static int get receiveTimeout =>
      int.tryParse(dotenv.env['API_RECEIVE_TIMEOUT'] ?? '30') ?? 30;
}