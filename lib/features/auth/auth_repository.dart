import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import 'auth_models.dart';

class AuthRepository {
  final Dio _dio = getIt<Dio>();

  Future<ApiResult<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/Auth/login',
        data: {'email': email, 'password': password},
      );

      return ApiResult.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      String message = "Connection Error";
      if (e.response?.data is Map<String, dynamic>) {
        message = e.response!.data['message'] ?? message;
      } else if (e.response?.data is String) {
        message = e.response!.data;
      }
      return ApiResult(
        isSuccess: false,
        message: message,
      );
    }
  }

  // 👇 ADD THIS NEW METHOD FOR REGISTRATION 👇
  Future<ApiResult<AuthResponse>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/Auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      return ApiResult.fromJson(
        response.data, 
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      String message = "Registration Failed";
      if (e.response?.data is Map<String, dynamic>) {
        message = e.response!.data['message'] ?? message;
      } else if (e.response?.data is String) {
        message = e.response!.data;
      }
      return ApiResult(
        isSuccess: false, 
        message: message,
      );
    }
  }
}
