import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import '../../core/storage/storage_service.dart';
import 'goal_models.dart';

class GoalsRepository {
  final Dio _dio = getIt<Dio>();
  final _storage = getIt<StorageService>();

/// Fetch goals data with offline-first support
  Future<ApiResult<List<Goal>>> getGoals() async {
    try {
      final response = await _dio.get('/Goals');
      
      // The API returns a list inside the 'data' field
      // return ApiResult.fromJson(
      final result = ApiResult.fromJson(
        response.data, 
        (json) {
          final list = json as List;
          return list.map((item) => Goal.fromJson(item)).toList();
        }
      );
      if (result.isSuccess && result.data != null) {
        await _storage.saveGoalsCache(result.data);
      }
      return result;
    } on DioException catch (e) {
      // API Failed -> Try to serve from cache
      final dynamic rawCachedData = _storage.getGoalsCache();
      if (rawCachedData is List) {
        final List<Goal> cachedData = rawCachedData.cast<Goal>();
        return ApiResult(
          isSuccess: true,
          data: cachedData,
          message: "Loaded from cache (Offline)",
        );
      }
      String message = "Failed to load goals";
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

  Future<ApiResult<Goal>> createGoal(CreateGoalDto dto) async {
    try {
      final response = await _dio.post('/Goals', data: dto.toJson());
      
      return ApiResult.fromJson(
        response.data, 
        (json) => Goal.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      String message = "Failed to create goal";
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

  // 👇 ADD THESE NEW METHODS 👇
  Future<ApiResult<Goal>> updateGoal(String id, CreateGoalDto dto) async {
    try {
      final response = await _dio.put('/Goals/$id', data: dto.toJson());
      return ApiResult.fromJson(
        response.data, 
        (json) => Goal.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      String message = "Failed to update goal";
      if (e.response?.data is Map<String, dynamic>) {
        message = e.response!.data['message'] ?? message;
      } else if (e.response?.data is String) {
        message = e.response!.data;
      }
      return ApiResult(isSuccess: false, message: message);
    }
  }

  Future<ApiResult<void>> deleteGoal(String id) async {
    try {
      await _dio.delete('/Goals/$id');
      // Delete typically returns just the base Result, no generic data
      return ApiResult(isSuccess: true, message: "Goal deleted");
    } on DioException catch (e) {
      String message = "Failed to delete goal";
      if (e.response?.data is Map<String, dynamic>) {
        message = e.response!.data['message'] ?? message;
      } else if (e.response?.data is String) {
        message = e.response!.data;
      }
      return ApiResult(isSuccess: false, message: message);
    }
  }
}