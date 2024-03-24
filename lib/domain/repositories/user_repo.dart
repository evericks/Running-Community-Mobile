import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants.dart';
import '../../utils/get_it.dart';
import '../../utils/messages.dart';
import '../models/user.dart';

final Dio _apiClient = getIt.get<Dio>();

class UserRepo {
  Future<void> login({required String username, required String password}) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/users',
        data: {
          'phone': username,
          'password': password,
        },
      );
      var accessToken = response.data['accessToken'];
      if (accessToken == null || accessToken == '') {
        throw Exception(msg_login_token_invalid);
      }
      await setValue(AppConstant.TOKEN_KEY, accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(msg_server_error);
      }
    }
  }

  Future<User> getUserProfile() async {
    try {
      final response = await _apiClient.post('/api/auth/users/sign-in-with-token');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(msg_server_error);
      }
    }
  }
}