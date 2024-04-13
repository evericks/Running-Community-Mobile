import 'package:dio/dio.dart';
import 'package:running_community_mobile/domain/models/archivements.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

final Dio _apiClient = getIt.get<Dio>();

class ArchivementRepo {
  Future<Archivements> getArchivements(
      {String? name,
      String? userId,
      String? tournamentId,
      int? pageNumber,
      int? pageSize}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (name != null) {
        queryParameters['name'] = name;
      }
      if (userId != null) {
        queryParameters['userId'] = userId;
      }
      if (tournamentId != null) {
        queryParameters['tournamentId'] = tournamentId;
      }
      if (pageNumber != null) {
        queryParameters['pageNumber'] = pageNumber;
      }
      if (pageSize != null) {
        queryParameters['pageSize'] = pageSize;
      }
      final response = await _apiClient.get('/api/archivements');
      return Archivements.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getArchivements: $e');
      throw Exception(msg_server_error);
    }
  }
}
