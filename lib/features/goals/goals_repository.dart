import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import 'goal_models.dart';

class GoalsRepository {
  final Dio _dio = getIt<Dio>();

  Future<ApiResult<List<Goal>>> getGoals() async {
    try {
      final response = await _dio.get('/Goals');
      
      // The API returns a list inside the 'data' field
      return ApiResult.fromJson(
        response.data, 
        (json) {
          final list = json as List;
          return list.map((item) => Goal.fromJson(item)).toList();
        }
      );
    } on DioException catch (e) {
      return ApiResult(
        isSuccess: false, 
        message: e.response?.data['message'] ?? "Failed to load goals"
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
      return ApiResult(
        isSuccess: false, 
        message: e.response?.data['message'] ?? "Failed to create goal"
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
      return ApiResult(isSuccess: false, message: e.response?.data['message'] ?? "Failed to update goal");
    }
  }

  Future<ApiResult<void>> deleteGoal(String id) async {
    try {
      await _dio.delete('/Goals/$id');
      // Delete typically returns just the base Result, no generic data
      return ApiResult(isSuccess: true, message: "Goal deleted");
    } on DioException catch (e) {
      return ApiResult(isSuccess: false, message: e.response?.data['message'] ?? "Failed to delete goal");
    }
  }
}