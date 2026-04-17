import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import '../../core/storage/storage_service.dart';
import 'dashboard_models.dart';

class DashboardRepository {
  final Dio _dio = getIt<Dio>();
  final _storage = getIt<StorageService>();

  /// Fetch dashboard data with offline-first support
  Future<ApiResult<DashboardData>> getDashboardData() async {
    try {
      final response = await _dio.get('/Dashboard');

      final result = ApiResult.fromJson(
        response.data,
        (json) => DashboardData.fromJson(json as Map<String, dynamic>),
      );

      if (result.isSuccess && result.data != null) {
        // Cache the successful result
        await _storage.saveDashboardCache(result.data);
      }

      return result;
    } on DioException catch (e) {
      // API Failed -> Try to serve from cache
      final cachedData = getCachedDashboardData();
      if (cachedData != null) {
        return ApiResult(
          isSuccess: true,
          data: cachedData,
          message: "Loaded from cache (Offline)",
        );
      }

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

  DashboardData? getCachedDashboardData() {
    final dynamic data = _storage.getDashboardCache();
    if (data is DashboardData) {
      return data;
    }
    return null;
  }
}
