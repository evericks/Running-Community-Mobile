import 'package:dio/dio.dart';
import 'package:running_community_mobile/domain/models/reacts.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

final Dio _apiClient = getIt.get<Dio>();

class PostReactRepo {

  Future<Reacts> getPostReacts({String? postId, int? pageSize, int? pageNumber}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (postId != null) queryParameters['postId'] = postId;
      if (pageSize != null) queryParameters['pageSize'] = pageSize;
      final response = await _apiClient.get('/api/post-reacts', queryParameters: queryParameters);
      return Reacts.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getPostReacts: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Reacts> createPostReact({required String postId}) async {
    try {
      var res = await _apiClient.post('/api/post-reacts', data: {'postId': postId});
      return Reacts.fromJson(res.data);
    } on DioException catch (e) {
      print('Error at createPostReact: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Reacts> deletePostReact({required String postId}) async {
    try {
      var res = await _apiClient.delete('/api/post-reacts/$postId');
      return Reacts.fromJson(res.data);
    } on DioException catch (e) {
      print('Error at deletePostReact: $e');
      throw Exception(msg_server_error);
    }
  }
}