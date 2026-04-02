class CreateTransactionDto {
  final double amount;
  final int type; // 0: Income, 1: Expense, 2: Saving
  final String description;
  final DateTime date;
  final String? goalId;

  CreateTransactionDto({
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    this.goalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'description': description,
      // Convert DateTime to ISO 8601 string for ASP.NET
      'date': date.toUtc().toIso8601String(), 
      'goalId': goalId,
    };
  }
}