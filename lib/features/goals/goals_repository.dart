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
}