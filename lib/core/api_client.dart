import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/auth_notifier.dart';
import 'storage/storage_service.dart';

class ApiClient {
  late Dio dio;
  
  // Update this to your local IP if testing on a real device!
  static const String baseUrl = "http://10.14.214.174:5115/api"; 

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add Interceptors for JWT and Auth handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Token expired or unauthorized -> Force Logout
            GetIt.instance<AuthNotifier>().logout();
          }
          return handler.next(e);
        },
      ),
    );
  }
}


