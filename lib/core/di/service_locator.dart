import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../api_client.dart';
import '../../features/auth/auth_notifier.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // 1. Register AuthNotifier first (used by ApiClient)
  getIt.registerSingleton<AuthNotifier>(AuthNotifier());

  // 2. Register ApiClient
  final apiClient = ApiClient();
  getIt.registerSingleton<ApiClient>(apiClient);

  // 3. Register the Dio instance from ApiClient for general use
  getIt.registerSingleton<Dio>(apiClient.dio);
}