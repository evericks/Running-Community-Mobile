import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:running_community_mobile/domain/repositories/archivement_repo.dart';
import 'package:running_community_mobile/domain/repositories/comment_repo.dart';
import 'package:running_community_mobile/domain/repositories/postReact_repo.dart';
import 'package:running_community_mobile/domain/repositories/post_repo.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';

import '../domain/repositories/group_repo.dart';
import 'dio.dart';

final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);

  getIt.registerLazySingleton(() => UserRepo());
  getIt.registerLazySingleton(() => ArchivementRepo());
  getIt.registerLazySingleton(() => GroupRepo());
  getIt.registerLazySingleton(() => PostRepo());
  getIt.registerLazySingleton(() => PostReactRepo());
  getIt.registerLazySingleton(() => PostCommentRepo());
}