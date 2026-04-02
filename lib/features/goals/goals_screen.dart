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
                // 👇 Pass context and ref
                return _buildGoalCard(context, ref, goals[index]); 
              },
            ),
          );
        },
      ),
    );
  }

 Widget _buildGoalCard(BuildContext context, WidgetRef ref, Goal goal) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final safeProgress = goal.progress.clamp(0.0, 1.0);
    
    // 👇 Wrap in Dismissible for Swipe-To-Delete
    return Dismissible(
      key: Key(goal.id),
      direction: DismissDirection.endToStart, // Swipe right to left
      background: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        // Show a confirmation dialog before deleting!
        return await showDialog(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text('Delete Goal?', style: TextStyle(color: Colors.white)),
            content: const Text('Are you sure you want to delete this goal? This cannot be undone.', style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // Perform the delete action
        ref.read(goalsControllerProvider.notifier).deleteGoal(goal.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Goal Deleted"), backgroundColor: Colors.redAccent));
      },
      // 👇 Wrap the actual card in a GestureDetector for Tap-To-Edit
      child: GestureDetector(
        onTap: () => _showAddGoalSheet(context, ref, goal),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(goal.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.tealAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text("${(safeProgress * 100).toInt()}%", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currencyFormat.format(goal.currentAmount), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("of ${currencyFormat.format(goal.targetAmount)}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: safeProgress, minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(width: 6),
                  Text("Target: ${DateFormat('MMM yyyy').format(goal.deadline)}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  // 👇 Add the optional Goal parameter
  void _showAddGoalSheet(BuildContext context, WidgetRef ref, [Goal? goal]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => AddGoalSheet(existingGoal: goal), // Pass it to the sheet
    );
  }
}
