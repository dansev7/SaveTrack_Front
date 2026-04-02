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
      return ApiResult(
        isSuccess: false,
        message: e.response?.data['message'] ?? "Connection Error",
      );
    }
  }
}
