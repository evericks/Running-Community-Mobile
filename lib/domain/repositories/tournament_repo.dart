import 'package:dio/dio.dart';
import 'package:running_community_mobile/domain/models/user.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import '../../utils/messages.dart';
import '../models/tournaments.dart';

final Dio _apiClient = getIt.get<Dio>();

class TournamentRepo {
  Future<Tournaments> getTournaments({String? title, String? startTime, String? endTime, double? minDistance, double? maxDistance, double? longitude, double? latitude, int? pageSize, int? pageNumber}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (title != null) queryParameters['title'] = title;
      if (startTime != null) queryParameters['duration.startTime'] = startTime;
      if (endTime != null) queryParameters['duration.endTime'] = endTime;
      if (minDistance != null) queryParameters['distance.minDistance'] = minDistance;
      if (maxDistance != null) queryParameters['distance.maxDistance'] = maxDistance;
      if (longitude != null) queryParameters['address.longitude'] = longitude;
      if (latitude != null) queryParameters['address.latitude'] = latitude;
      if (pageSize != null) queryParameters['pageSize'] = pageSize;
      if (pageNumber != null) queryParameters['pageNumber'] = pageNumber;
      final response = await _apiClient.get('/api/tournaments', queryParameters: queryParameters);
      return Tournaments.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getTournaments: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Tournament> getTournamentById(String id) async {
    try {
      final response = await _apiClient.get('/api/tournaments/$id');
      return Tournament.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getTournamentById: $e');
      throw Exception(msg_server_error);
    }
  }

  Future<Tournaments> getTournamentsAttendedk() async {
    try {
      final response = await _apiClient.get('/api/tournaments/attendeds');
      return Tournaments.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getTournamentsAttendedk: $e');
      throw Exception(msg_server_error);
    }
  }
  

  Future<User> attendTournament(String tournamentId) async {
    try {
      var res = await _apiClient.post('/api/user-tournaments', data: {'tournamentId': tournamentId});
      return User.fromJson(res.data);
    } on DioException catch (e) {
      print('Error at attendTournament: $e');
      throw Exception(msg_server_error);
    }
  }
}