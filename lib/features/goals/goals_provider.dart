import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'goals_repository.dart';
import 'goal_models.dart';
import '../dashboard/dashboard_provider.dart';
part 'goals_provider.g.dart';

@riverpod
class GoalsController extends _$GoalsController {
  @override
  Future<List<Goal>> build() async {
    // Automatically fetch goals when this provider is watched
    final result = await GoalsRepository().getGoals();
    
    if (result.isSuccess && result.data != null) {
      return result.data!;
    } else {
      throw Exception(result.message ?? "Failed to load goals");
    }
  }

  Future<bool> addGoal(CreateGoalDto dto) async {
    final result = await GoalsRepository().createGoal(dto);
    
    if (result.isSuccess) {
      // 🔥 Invalidate self: This forces the build() method to run again,
      // instantly refreshing the UI with the newly created goal!
      ref.invalidateSelf();
      return true;
    }
    return false;
  }

  // 👇 ADD THESE NEW METHODS 👇
  Future<bool> updateGoal(String id, CreateGoalDto dto) async {
    final result = await GoalsRepository().updateGoal(id, dto);
    if (result.isSuccess) {
      ref.invalidateSelf(); // Refresh the goals list
      return true;
    }
    return false;
  }

  Future<bool> deleteGoal(String id) async {
    final result = await GoalsRepository().deleteGoal(id);
    if (result.isSuccess) {
      ref.invalidateSelf(); // Refresh the goals list
      // Also invalidate dashboard in case money was tied to this goal
      ref.invalidate(dashboardDataProvider); 
      return true;
    }
    return false;
  }
}