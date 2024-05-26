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

  Future<int> createGroup({required String name, required String description, int? maxAge, int? minAge, String? gender, required XFile thumbnail}) async {
    try {
      FormData formData = FormData.fromMap({
        'thumbnail': await MultipartFile.fromFile(thumbnail.path, filename: '$name-thumbnail'),
        'name': name,
        'description': description,
        if(maxAge != null) 'maxAge': maxAge,
        if(minAge != null) 'minAge': minAge,
        if(gender != null) 'gender' : gender,
      });
      final response = await _apiClient.post('/api/groups', data: formData, options: Options(contentType: Headers.multipartFormDataContentType));
      return response.statusCode!;
    } on DioException catch (e) {
      print('Error at createGroup: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Group> getGroupById(String id) async {
    try {
      final response = await _apiClient.get('/api/groups/$id');
      return Group.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getGroupById: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> joinGroup({required String userId, required String groupId}) async {
    try {
      Map<String, dynamic> data = {
        'userId': userId,
        'groupId': groupId,
      };
      await _apiClient.post('/api/group-members', data: data);
      return true;
    } on DioException catch (e) {
      print('Error at joinGroup: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> joinRequestProcess({required String memId, String? role, String? status}) async {
    try {
      Map<String, dynamic> data = {
        if(role != null) 'role': role,
        if(status != null) 'status': status,
      };
      await _apiClient.put('/api/group-members/$memId', data: data);
      return true;
    } on DioException catch (e) {
      print('Error at joinRequestProcess: $e');
      throw Exception(msg_server_error);
    }
  }
}