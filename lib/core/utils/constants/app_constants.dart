import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // * url
  static String get baseUrl =>
      '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}';

  // * shared preferences
  static const String accessToken = 'access_token';
  static const String isRemember = 'is_remember';
  static const String refreshToken = 'refresh_token';
  static const String username = 'username';
  static const String password = 'password';
}
