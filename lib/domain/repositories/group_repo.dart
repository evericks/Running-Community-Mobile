import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import '../../utils/messages.dart';
import '../models/groups.dart';

final Dio _apiClient = getIt.get<Dio>();

class GroupRepo {
  Future<Groups> getGroups({String? name, String? userId, int? pageNumber, int? pageSize}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (name != null) queryParameters['name'] = name;
      if (userId != null) queryParameters['userId'] = userId;
      if (pageNumber != null) queryParameters['pageNumber'] = pageNumber;
      if (pageSize != null) queryParameters['pageSize'] = pageSize;
      final response = await _apiClient.get('/api/groups', queryParameters: queryParameters);
      return Groups.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getGroups: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<int> createGroup({required String name, required String description, required String rule, required XFile thumbnail}) async {
    try {
      FormData formData = FormData.fromMap({
        'thumbnail': await MultipartFile.fromFile(thumbnail.path, filename: '$name-thumbnail'),
        'name': name,
        'description': description,
        'rule': rule,
      });
      final response = await _apiClient.post('/api/groups', data: formData, options: Options(contentType: Headers.multipartFormDataContentType));
      return response.statusCode!;
    } on DioException catch (e) {
      print('Error at createGroup: $e');
      throw Exception(msg_server_error);
    }
  }
}