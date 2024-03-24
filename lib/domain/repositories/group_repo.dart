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

  Future<int> createGroup({required String name, required String description, required String userId}) async {
    try {
      final response = await _apiClient.post('/api/groups', data: {
        'name': name,
        'description': description,
        'userId': userId,
      });
      return response.statusCode!;
    } on DioException catch (e) {
      print('Error at createGroup: $e');
      throw Exception(msg_server_error);
    }
  }
}