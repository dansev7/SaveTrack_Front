class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
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
class CreateGoalDto {
  final String name;
  final double targetAmount;
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