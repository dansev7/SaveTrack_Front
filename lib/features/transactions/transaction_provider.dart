import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'transaction_repository.dart';
import 'transaction_models.dart';
import '../dashboard/dashboard_provider.dart';

part 'transaction_provider.g.dart';

@riverpod
class CreateTransactionController extends _$CreateTransactionController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> submitTransaction(CreateTransactionDto dto) async {
    state = const AsyncValue.loading();
    
    final result = await TransactionRepository().createTransaction(dto);
    
    if (result.isSuccess) {
      state = const AsyncValue.data(null);
      // 🔥 CRITICAL: This tells Riverpod to fetch the latest dashboard data 
      // so the new transaction instantly appears on the home screen!
      ref.invalidate(dashboardDataProvider);
      return true;
    } else {
      state = AsyncValue.error(result.message ?? "Failed to save", StackTrace.current);
      return false;
    }
  }

  // 👇 ADD THIS NEW METHOD 👇
  Future<bool> updateTransaction(String id, CreateTransactionDto dto) async {
    state = const AsyncValue.loading();
    
    final result = await TransactionRepository().updateTransaction(id, dto);
    
    if (result.isSuccess) {
      state = const AsyncValue.data(null);
      // Force dashboard to refresh with the updated data
      ref.invalidate(dashboardDataProvider);
      return true;
    } else {
      state = AsyncValue.error(result.message ?? "Failed to update", StackTrace.current);
      return false;
    }
  }
}