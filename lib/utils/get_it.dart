import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'dio.dart';

final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);
}