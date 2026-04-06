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
      String message = "Failed to load profile";
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
      String message = "Failed to update profile";
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