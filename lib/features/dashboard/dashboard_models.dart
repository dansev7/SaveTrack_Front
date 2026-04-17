import 'package:hive_ce/hive_ce.dart';

part 'dashboard_models.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final int type; 
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Robust type parsing (handles 0, 1, 2 OR "Income", "Expense", "Saving")
    final rawType = json['type'].toString();
    int parsedType;
    if (rawType.toLowerCase() == 'income' || rawType == '0') {
      parsedType = 0;
    } else if (rawType.toLowerCase() == 'expense' || rawType == '1') {
      parsedType = 1;
    } else if (rawType.toLowerCase() == 'saving' || rawType == '2') {
      parsedType = 2;
    } else {
      parsedType = 0; // Default
    }

    return Transaction(
      id: json['id'].toString(),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: parsedType,
      description: json['description']?.toString() ?? '',
      date: DateTime.parse(json['date'].toString()),
    );
  }
}

@HiveType(typeId: 1)
class DashboardData {
  @HiveField(0)
  final double totalBalance;
  @HiveField(1)
  final double monthlyIncome;
  @HiveField(2)
  final double monthlyExpenses;
  @HiveField(3)
  final double monthlySavings;
  @HiveField(4)
  final List<Transaction> recentTransactions;

  DashboardData({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlySavings,
    required this.recentTransactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      // Safely parse all numbers
      totalBalance: double.tryParse(json['totalBalance'].toString()) ?? 0.0,
      monthlyIncome: double.tryParse(json['monthlyIncome'].toString()) ?? 0.0,
      monthlyExpenses: double.tryParse(json['monthlyExpenses'].toString()) ?? 0.0,
      monthlySavings: double.tryParse(json['monthlySavings'].toString()) ?? 0.0,
      // Safely map the list, defaulting to empty if null
      recentTransactions: (json['recentTransactions'] as List?)
          ?.map((item) => Transaction.fromJson(item))
          .toList() ?? [],
    );
  }
}