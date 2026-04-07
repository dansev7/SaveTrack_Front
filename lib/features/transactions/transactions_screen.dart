import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import './transaction_provider.dart';
import '../dashboard/dashboard_models.dart';
import 'add_transaction_sheet.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  void _showTransactionSheet(BuildContext context, [Transaction? tx]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => AddTransactionSheet(existingTransaction: tx),
    );
  }

  @override
 @override
Widget build(BuildContext context, WidgetRef ref) {
  // 1. Watch the correct provider
  final transactionsAsync = ref.watch(allTransactionsProvider);

  return Scaffold(
    backgroundColor: const Color(0xFF121212),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('All Transactions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.tealAccent,
      child: const Icon(Icons.add, color: Colors.black),
      onPressed: () => _showTransactionSheet(context),
    ),
    body: transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
      error: (err, stack) => Center(child: Text(err.toString(), style: const TextStyle(color: Colors.redAccent))),
      data: (transactions) { // 2. 'transactions' is now a List<Transaction>, not DashboardData
        if (transactions.isEmpty) {
          return const Center(child: Text("No transactions yet.", style: TextStyle(color: Colors.white70)));
        }

        return RefreshIndicator(
          color: Colors.tealAccent,
          backgroundColor: const Color(0xFF1E1E1E),
          // 3. Invalidate the specific list provider
          onRefresh: () async => ref.invalidate(allTransactionsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: transactions.length, // 4. Use the list length directly
            itemBuilder: (context, index) {
              return _buildTransactionTile(context, transactions[index]);
            },
          ),
        );
      },
    ),
  );
}
  Widget _buildTransactionTile(BuildContext context, Transaction tx) {
    final currencyFormat = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);
    final isIncome = tx.type == 0;
    final isSaving = tx.type == 2;
    final color = isIncome ? Colors.greenAccent : (isSaving ? Colors.blueAccent : Colors.redAccent);
    final icon = isIncome ? Icons.trending_up : (isSaving ? Icons.savings_outlined : Icons.trending_down);

    return GestureDetector(
      onTap: () => _showTransactionSheet(context, tx), // 👈 Triggers Edit mode in the sheet!
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          title: Text(tx.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(DateFormat('MMM dd, yyyy').format(tx.date), style: TextStyle(color: Colors.white.withOpacity(0.5))),
          trailing: Text(
            "${isIncome || isSaving ? '+' : '-'}${currencyFormat.format(tx.amount)}",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}