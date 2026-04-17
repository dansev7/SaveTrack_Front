import 'package:hive_ce/hive_ce.dart';

part 'goal_models.g.dart';

@HiveType(typeId: 2)
class Goal {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double targetAmount;
  @HiveField(3)
  final double currentAmount;
  @HiveField(4)
  final DateTime deadline;
  @HiveField(5)
  final double progress;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.progress,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'Unnamed Goal',
      // Bulletproof parsing
      targetAmount: double.tryParse(json['targetAmount'].toString()) ?? 0.0,
      currentAmount: double.tryParse(json['currentAmount'].toString()) ?? 0.0,
      deadline: DateTime.parse(json['deadline'].toString()),
      progress: double.tryParse(json['progress'].toString()) ?? 0.0,
    );
  }
}

// We also need a DTO for creating/updating a goal
@HiveType(typeId: 3)
class CreateGoalDto {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double targetAmount;
  @HiveField(2)
  final DateTime deadline;

  CreateGoalDto({
    required this.name,
    required this.targetAmount,
    required this.deadline,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'deadline': deadline.toUtc().toIso8601String(),
    };
  }
}