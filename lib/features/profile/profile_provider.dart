import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'profile_repository.dart';
import 'profile_models.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<UserProfile?> build() async {
    final result = await ProfileRepository().getProfile();
    if (result.isSuccess && result.data != null) {
      return result.data;
    } else {
      throw Exception(result.message ?? "Failed to load profile");
    }
  }

  Future<bool> updateName(String newName) async {
    final result = await ProfileRepository().updateName(newName);
    if (result.isSuccess) {
      ref.invalidateSelf(); // Refresh the profile screen!
      return true;
    }
    return false;
  }
}