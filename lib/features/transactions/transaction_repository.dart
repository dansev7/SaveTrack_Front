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
      return ApiResult(
        isSuccess: false, 
        message: e.response?.data['message'] ?? "Failed to create transaction"
      );
    }
  }
}