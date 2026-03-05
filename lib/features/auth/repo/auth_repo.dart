import 'package:chat_app/core/datasource/dio/dio_client.dart';
import 'package:chat_app/core/datasource/exception/api_response.dart';
import 'package:chat_app/core/utils/constants/app_constants.dart';
import 'package:chat_app/features/auth/models/body/login_post_model.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthRepo {
  final DioClient? dc;
  final SharedPreferences? sf;

  AuthRepo({required this.dc, required this.sf});

  // * save access token
  Future<void> saveAccessToken(String accessToken) async {
    dc!.updateHeader(accessToken);
    try {
      await sf?.setString(AppConstants.accessToken, accessToken);
    } catch (e) {
      rethrow;
    }
  }

  // * get access token
  String getAccessToken() {
    return sf?.getString(AppConstants.accessToken) ?? '';
  }

  // * clear  access token
  Future<void> clearAccessToken() async {
    dc!.updateHeader('');
    try {
      await sf?.remove(AppConstants.accessToken);
    } catch (e) {
      rethrow;
    }
  }
}
