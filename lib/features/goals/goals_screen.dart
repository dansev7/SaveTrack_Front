import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'goals_provider.dart';
import 'goal_models.dart';
import 'add_goal_sheet.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Savings Goals',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // We will wire this up to an "Add Goal" bottom sheet shortly!
          _showAddGoalSheet(context, ref);
        },
      ),
      body: goalsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.tealAccent),
        ),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(
              child: Text(
                "No goals yet. Tap + to start saving!",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.tealAccent,
            backgroundColor: const Color(0xFF1E1E1E),
            onRefresh: () async => ref.invalidate(goalsControllerProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return _buildGoalCard(goals[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    // Ensure progress is between 0.0 and 1.0 for the indicator
    final safeProgress = goal.progress.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                goal.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${(safeProgress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormat.format(goal.currentAmount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "of ${currencyFormat.format(goal.targetAmount)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Beautiful Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: safeProgress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.tealAccent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(width: 6),
              Text(
                "Target: ${DateFormat('MMM yyyy').format(goal.deadline)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Placeholder for the Add Goal Sheet (we will build the actual form next if you want!)
  void _showAddGoalSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This allows the sheet to resize when the keyboard pops up!
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const AddGoalSheet(),
    );
  }
}
