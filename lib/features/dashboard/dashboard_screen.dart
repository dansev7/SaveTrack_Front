import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../auth/auth_provider.dart';
import 'dashboard_provider.dart';
import 'dashboard_models.dart';
import '../transactions/add_transaction_sheet.dart';
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
        title: const Text('Overview',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
     floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // Trigger Bottom Sheet instead of Router
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (context) => const AddTransactionSheet(),
          );
        },
      ),
      body: dashboardAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.tealAccent)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(err.toString(), style: const TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () => ref.invalidate(dashboardDataProvider),
                child: const Text("Retry",
                    style: TextStyle(color: Colors.tealAccent)),
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
                _buildBalanceCards(data.totalBalance, data.monthlySavings),
                const SizedBox(height: 24),
                _buildSummaryRow(data.monthlyIncome, data.monthlyExpenses, data.monthlySavings),
                const SizedBox(height: 32),
                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                ...data.recentTransactions
                    .map((tx) => _buildTransactionTile(context, tx)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCards(double total, double savings) {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceCard(
            "Balance",
            total,
            [const Color(0xFF004D40), const Color(0xFF00796B)],
            Icons.account_balance_wallet_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBalanceCard(
            "Savings",
            savings,
            [const Color(0xFF1A237E), const Color(0xFF283593)],
            Icons.savings_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String title, double amount, List<Color> colors, IconData icon) {
    final currencyFormat = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 13)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              currencyFormat.format(amount),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(double income, double expense, double savings) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildSummaryCard(
                    "Income", income, Icons.trending_up, Colors.greenAccent)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildSummaryCard(
                    "Expense", expense, Icons.trending_down, Colors.redAccent)),
          ],
        ),
        
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, double amount, IconData icon, Color iconColor) {
    final currencyFormat = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);
    return Container(
      width: double.infinity,
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
                decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction tx) {
    final currencyFormat = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);
    
    // 0: Income, 1: Expense, 2: Saving
    final isIncome = tx.type == 0;
    final isSaving = tx.type == 2;

    final color = isIncome 
        ? Colors.greenAccent 
        : (isSaving ? Colors.blueAccent : Colors.redAccent);
    
    final icon = isIncome
        ? Icons.trending_up
        : (isSaving ? Icons.savings_outlined : Icons.trending_down);
    
    final prefix = isIncome || isSaving ? "+" : "-";

    return GestureDetector(
      onTap: () {
    // Trigger Bottom Sheet with Data
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF1E1E1E),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (context) => AddTransactionSheet(existingTransaction: tx),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          title: Text(tx.description,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(
            DateFormat('MMM dd, yyyy').format(tx.date),
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          trailing: Text(
            "$prefix${currencyFormat.format(tx.amount)}",
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}