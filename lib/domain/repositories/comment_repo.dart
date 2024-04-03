import 'package:dio/dio.dart';

import '../../utils/get_it.dart';
import '../../utils/messages.dart';
import '../models/posts.dart';

final Dio _apiClient = getIt.get<Dio>();

class PostCommentRepo {
  Future<PostComment> getPostCommentById({String? postId, int? pageSize, int? pageNumber}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (postId != null) queryParameters['postId'] = postId;
      if (pageSize != null) queryParameters['pageSize'] = pageSize;
      if (pageNumber != null) queryParameters['pageNumber'] = pageNumber;
      final response = await _apiClient.get('/api/post-comments', queryParameters: queryParameters);
      return PostComment.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getComments: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<void> createPostComment({required String postId, required String content}) async {
    try {
      await _apiClient.post('/api/post-comments', data: {
        'postId': postId,
        'content': content,
      });
    } on DioException catch (e) {
      print('Error at createPostComment: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> createPostCommentReact({required String commentId}) async {
    try {
      await _apiClient.post('/api/post-comment-reacts', data: {
        'postCommentId': commentId,
      });
      return true;
    } on DioException catch (e) {
      print('Error at createPostCommentReact: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> deletePostCommentReact({required String commentId}) async {
    try {
      await _apiClient.delete('/api/post-comment-reacts/$commentId');
      return true;
    } on DioException catch (e) {
      print('Error at deletePostCommentReact: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> createReplyCommentReact({required String replyCommentId}) async {
    try {
      await _apiClient.post('/api/reply-comment-reacts', data: {
        'replyCommentId': replyCommentId,
      });
      return true;
    } on DioException catch (e) {
      print('Error at createReplyCommentReact: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> deleteReplyCommentReact({required String replyCommentId}) async {
    try {
      await _apiClient.delete('/api/reply-comment-reacts/$replyCommentId');
      return true;
    } on DioException catch (e) {
      print('Error at deleteReplyCommentReact: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> createReplyComment({required String commentId, required String content}) async {
    try {
      await _apiClient.post('/api/reply-comments', data: {
        'postCommentId': commentId,
        'content': content,
      });
      return true;
    } on DioException catch (e) {
      print('Error at createReplyComment: $e');
      throw Exception(msg_server_error);
    }
  }
}