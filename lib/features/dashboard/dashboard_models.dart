class Transaction {
  final String id;
  final double amount;
  final int type; 
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      // Bulletproof number parsing (handles both ints, doubles, and strings)
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: int.tryParse(json['type'].toString()) ?? 0,
      description: json['description']?.toString() ?? '',
      date: DateTime.parse(json['date'].toString()),
    );
  }
}

class DashboardData {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlySavings;
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