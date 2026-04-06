import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import 'dashboard_models.dart';

class DashboardRepository {
  final Dio _dio = getIt<Dio>();

  Future<ApiResult<DashboardData>> getDashboardData() async {
    try {
      final response = await _dio.get('/Dashboard');

      return ApiResult.fromJson(
        response.data,
        (json) => DashboardData.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      String message = "Failed to load dashboard";
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
