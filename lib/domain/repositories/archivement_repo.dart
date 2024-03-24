import 'package:dio/dio.dart';
import 'package:running_community_mobile/domain/models/archivements.dart';
import 'package:running_community_mobile/utils/get_it.dart';
import 'package:running_community_mobile/utils/messages.dart';

final Dio _apiClient = getIt.get<Dio>();

class ArchivementRepo {
  Future<Archivements> getArchivements() async {
    try {
      final response = await _apiClient.get('/api/archivements');
      return Archivements.fromJson(response.data);
    } on DioException catch (e) {
      print('Error at getArchivements: $e');
      throw Exception(msg_server_error);
    }
  }
}