import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../storage/storage_service.dart';

final getIt = GetIt.instance;


// Inside your Dio setup in lib/core/di/service_locator.dart

void setupLocator() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.14.214.142:5115/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // 👇 ADD THIS INTERCEPTOR 👇
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  getIt.registerSingleton<Dio>(dio);
}