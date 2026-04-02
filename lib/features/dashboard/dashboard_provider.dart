import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dashboard_repository.dart';
import 'dashboard_models.dart';

part 'dashboard_provider.g.dart';

@riverpod
Future<DashboardData?> dashboardData(Ref ref) async {
  final result = await DashboardRepository().getDashboardData();
  
  if (result.isSuccess && result.data != null) {
    return result.data;
  } else {
    throw Exception(result.message ?? "Failed to fetch data");
  }
}