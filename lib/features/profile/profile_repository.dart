import 'dart:convert'; // 👈 ADD THIS IMPORT AT THE TOP
import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import 'profile_models.dart';

class ProfileRepository {
  final Dio _dio = getIt<Dio>();

  Future<ApiResult<UserProfile>> getProfile() async {
    try {
      final response = await _dio.get('/Profile');
      
      // 👇 THE FIX: Force decode if Dio handed us a raw string
      final dynamic responseData = response.data is String 
          ? jsonDecode(response.data) 
          : response.data;

      return ApiResult.fromJson(
        responseData, 
        (json) => UserProfile.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      return ApiResult(
        isSuccess: false, 
        message: e.response?.data['message'] ?? "Failed to load profile"
      );
    }
  }

  Future<ApiResult<UserProfile>> updateName(String newName) async {
    try {
      final response = await _dio.put('/Profile', data: {'name': newName});
      
      // 👇 Apply the same fix here just to be safe!
      final dynamic responseData = response.data is String 
          ? jsonDecode(response.data) 
          : response.data;

      return ApiResult.fromJson(
        responseData, 
        (json) => UserProfile.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      return ApiResult(
        isSuccess: false, 
        message: e.response?.data['message'] ?? "Failed to update profile"
      );
    }
  }
}