import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../api_client.dart';
import '../storage/storage_service.dart';
import '../../features/auth/auth_notifier.dart';

final getIt = GetIt.instance;

void setupLocator(StorageService storageService) {
  // 1. Register StorageService
  getIt.registerSingleton<StorageService>(storageService);

  // 2. Register AuthNotifier (injecting StorageService)
  final authNotifier = AuthNotifier(storageService);
  getIt.registerSingleton<AuthNotifier>(authNotifier);

  // 3. Register ApiClient
  final apiClient = ApiClient();
  getIt.registerSingleton<ApiClient>(apiClient);

  // 4. Register the Dio instance from ApiClient for general use
  getIt.registerSingleton<Dio>(apiClient.dio);
}