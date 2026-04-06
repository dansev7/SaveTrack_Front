import 'package:dio/dio.dart';
import '../../core/di/service_locator.dart';
import '../../core/models/api_result.dart';
import '../dashboard/dashboard_models.dart'; // To reuse the Transaction model
import 'transaction_models.dart';

class TransactionRepository {
  final Dio _dio = getIt<Dio>();

  Future<ApiResult<Transaction>> createTransaction(CreateTransactionDto dto) async {
    try {
      final response = await _dio.post('/Transactions', data: dto.toJson());
      
      return ApiResult.fromJson(
        response.data, 
        // We reuse the Transaction model from the dashboard slice for the response
        (json) => Transaction.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      String message = "Failed to create transaction";
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

  // 👇 ADD THIS NEW METHOD 👇
  Future<ApiResult<Transaction>> updateTransaction(String id, CreateTransactionDto dto) async {
    try {
      final response = await _dio.put('/Transactions/$id', data: dto.toJson());
      
      return ApiResult.fromJson(
        response.data, 
        (json) => Transaction.fromJson(json as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      String message = "Failed to update transaction";
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

