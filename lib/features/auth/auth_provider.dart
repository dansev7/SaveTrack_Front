import 'package:riverpod_annotation/riverpod_annotation.dart'; // Must be package import
import 'auth_repository.dart';
import 'auth_models.dart';
import '../../core/storage/storage_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<AuthResponse?> build() {
    final token = StorageService.getToken();
    return const AsyncValue.data(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await AuthRepository().login(email, password);
    
    if (result.isSuccess && result.data != null) {
      await StorageService.saveToken(result.data!.token);
      state = AsyncValue.data(result.data);
    } else {
      state = AsyncValue.error(result.message ?? "Login Failed", StackTrace.current);
    }
  }

  // 👇 ADD THIS NEW METHOD FOR REGISTRATION 👇
// Updated Registration Method
  Future<bool> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await AuthRepository().register(name, email, password);
    
    if (result.isSuccess) {
      // We do NOT save the token here. We want them to log in manually.
      state = const AsyncValue.data(null); 
      return true;
    } else {
      state = AsyncValue.error(result.message ?? "Registration Failed", StackTrace.current);
      return false;
    }
  }

  void logout() {
    StorageService.clear();
    state = const AsyncValue.data(null);
  }
}