import 'package:dio/dio.dart';

class ApiClient {
  late Dio dio;
  
  // Update this to your local IP if testing on a real device!
  static const String baseUrl = "http://10.14.214.30:5115/api"; 

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add Interceptor for JWT
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // We will fetch the token from Hive later
        // options.headers["Authorization"] = "Bearer $token";
        return handler.next(options);
      },
    ));
  }
}