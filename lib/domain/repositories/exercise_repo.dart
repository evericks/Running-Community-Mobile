import 'package:dio/dio.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

import '../models/exercises.dart';
import '../models/user_exercise_item.dart';

final Dio _apiClient = getIt.get<Dio>();

class ExerciseRepo {
  Future<Exercises> getExercises({String? name, int? pageSize, int? pageNumber}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (name != null) {
        queryParameters['name'] = name;
      }
      if (pageSize != null) {
        queryParameters['pageSize'] = pageSize;
      }
      if (pageNumber != null) {
        queryParameters['pageNumber'] = pageNumber;
      }
      final response = await _apiClient.get('/api/exercises', queryParameters: queryParameters);
      return Exercises.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getExercises: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Exercise> getExerciseById(String id) async {
    try {
      final response = await _apiClient.get('/api/exercises/$id');
      return Exercise.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getExercise: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<ExerciseItems> getExerciseItemById(String id) async {
    try {
      final response = await _apiClient.get('/api/exercise-items/$id');
      return ExerciseItems.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getExerciseItem: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<bool> markExerciseAsDone({required String id}) async {
    try {
      final response = await _apiClient.post('/api/user-exercise-items', data: {'exerciseItemId': id});
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error at markExerciseAsDone: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<List<UserExerciseItem>> getUserExerciseItem() async {
    try {
      final response = await _apiClient.get('/api/user-exercise-items');
      return (response.data as List).map((e) => UserExerciseItem.fromJson(e)).toList();
    } on DioException catch (e) {
      print('Error at getUserExerciseItemById: $e');
      throw Exception(msg_server_error);
    }
  }
}
