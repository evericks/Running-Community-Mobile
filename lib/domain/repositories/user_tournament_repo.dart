import 'package:dio/dio.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

import '../models/user_tournament.dart';

final Dio _apiClient = getIt.get<Dio>();

class UserTournamentRepo {
  Future<UsersTournament> getUsersTournament ({String? tournamentId, String? status, int? pageNumber, int? pageSize}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'tournamentId': tournamentId,
        'status': status,
        'pageNumber': pageNumber,
        'pageSize': pageSize
      };
      var res = await _apiClient.get('/api/user-tournaments', queryParameters: queryParameters);
      return UsersTournament.fromJson(res.data);
    } on DioException catch (e) {
      print("Error at getUsersTournament: $e");
      throw Exception(msg_server_error);
    }
  }
}