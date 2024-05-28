
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants.dart';
import '../../utils/get_it.dart';
import '../../utils/messages.dart';
import '../models/user.dart';

final Dio _apiClient = getIt.get<Dio>();

class UserRepo {
  static User user = User();
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
      user.id = response.data['id'];
      user.name = response.data['name'];
      user.phone = response.data['phone'];
      user.avatarUrl = response.data['avatarUrl'];
      user.address = response.data['address'];
      user.gender = response.data['gender'];
      user.dateOfBirth = response.data['dateOfBirth'];
      user.status = response.data['status'];
      user.createAt = response.data['createAt'];
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(msg_server_error);
      }
    }
  }

  Future<bool> signUp({required String name, required String phone, required String password, required DateTime dob}) async {
    try {
      await _apiClient.post(
        '/api/users',
        data: {
          'name': name,
          'phone': phone,
          'password': password,
          'dateOfBirth': dob.toString().substring(0, 10),
        },
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response!.data);
      } else if (e.response?.statusCode == 409) {
        throw Exception(msg_phone_exist);
      } else {
        throw Exception(msg_server_error);
      }
    }
  }

  Future<void> updateProfile({required String id, String? name, String? address, XFile? avatar, DateTime? dob, String? password, String? gender}) async {
    try {
      FormData formData = FormData.fromMap({
        if(avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path, filename: '$name-avatar'),
        if(name != null) 'name': name,
        if(address != null) 'address': address,
        if(dob != null) 'dateOfBirth': dob.toString().substring(0, 10),
        if(password != null) 'password': password,
        if(gender != null) 'gender' : gender
      });
      await _apiClient.put(
        '/api/users/$id',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType)
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response!.data);
      } else {
        throw Exception(msg_server_error);
      }
    }
  }

  Future<void> sendDeviceToken() async {
    var deviceToken = getStringAsync(AppConstant.DEVICE_TOKEN);
    try {
      await _apiClient.post('/api/device-tokens/users', data: {'deviceToken': deviceToken});
    } on DioException catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
