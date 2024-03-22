import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/utils/constants.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

final Dio apiClient = getIt.get<Dio>();

class UserRepo {
  Future<void> login({required String username, required String password}) async {
    try {
      final response = await apiClient.post(
        '/api/auth/users',
        data: {
          'phone': username,
          'password': password,
        },
      );
      var accessToken = response.data['accessToken'];
      print(accessToken);
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
}