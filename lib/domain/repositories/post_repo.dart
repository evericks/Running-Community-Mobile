import 'package:dio/dio.dart';
import 'package:running_community_mobile/domain/models/posts.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

final Dio _apiClient = getIt.get<Dio>();

class PostRepo {
  Future<Posts> getPosts({String? content, String? creatorId, String? groupId, int? pageSize, int? pageNumber}) async {
    try {
    Map<String, dynamic> queryParameters = {};
    if (content != null) queryParameters['content'] = content;
    if (creatorId != null) queryParameters['creatorId'] = creatorId;
    if (groupId != null) queryParameters['groupId'] = groupId;
    if (pageSize != null) queryParameters['pageSize'] = pageSize;
    if (pageNumber != null) queryParameters['pageNumber'] = pageNumber;
    final response = await _apiClient.get('/api/posts', queryParameters: queryParameters);
    return Posts.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getPosts: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Post> getPostById({required String postId}) async {
    try {
    final response = await _apiClient.get('/api/posts/$postId');
    return Post.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getPostById: $e');
      throw Exception(msg_server_error);
    }
  }
}