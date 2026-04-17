import 'package:hive_ce/hive_ce.dart';
import '../../features/dashboard/dashboard_models.dart';
import '../../features/goals/goal_models.dart';

class HiveAdapters {
  // Central registry of type IDs to prevent conflicts
  static const int transactionId = 0;
  static const int dashboardDataId = 1;
  static const int goalId = 2;
  static const int createGoalDtoId = 3;
  static const int transactionDtoId = 4;

  static void register() {
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(DashboardDataAdapter());
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(CreateGoalDtoAdapter());
    
  }
}
