import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../auth/auth_provider.dart';
import 'dashboard_provider.dart';
import 'dashboard_models.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the future provider
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Charcoal background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Overview', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.tealAccent),
            onPressed: () {
              // Show the Confirmation Dialog
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E), // Match our dark theme
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
                    actions: [
                      // Cancel Button
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(), // Just close the dialog
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      // Confirm Logout Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); // Close the dialog first
                          ref.read(authControllerProvider.notifier).logout(); // Clear state
                          context.go('/login'); // Route to login screen
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          context.push('/create-transaction');
        },
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(err.toString(), style: const TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () => ref.invalidate(dashboardDataProvider),
                child: const Text("Retry", style: TextStyle(color: Colors.tealAccent)),
              )
            ],
          ),
        ),
        data: (data) {
          if (data == null) return const Center(child: Text("No data found."));
          return RefreshIndicator(
            color: Colors.tealAccent,
            backgroundColor: const Color(0xFF1E1E1E),
            onRefresh: () async => ref.invalidate(dashboardDataProvider),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildTotalBalanceCard(data.totalBalance),
                const SizedBox(height: 24),
                _buildSummaryRow(data.monthlyIncome, data.monthlyExpenses),
                const SizedBox(height: 32),
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                ...data.recentTransactions.map((tx) => _buildTransactionTile(tx)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalBalanceCard(double balance) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Balance", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(double income, double expense) {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard("Income", income, Icons.arrow_downward, Colors.greenAccent)),
        const SizedBox(width: 16),
        Expanded(child: _buildSummaryCard("Expense", expense, Icons.arrow_upward, Colors.redAccent)),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount, IconData icon, Color iconColor) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Slightly lighter than background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isIncome = tx.type == 0;
    final isSaving = tx.type == 2;
    
    final color = isIncome ? Colors.greenAccent : (isSaving ? Colors.blueAccent : Colors.redAccent);
    final icon = isIncome ? Icons.add_circle_outline : (isSaving ? Icons.savings_outlined : Icons.remove_circle_outline);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(tx.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(tx.date),
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        trailing: Text(
          "${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}",
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}