import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'goal_models.dart';
import 'goals_provider.dart';

class AddGoalSheet extends ConsumerStatefulWidget {
  const AddGoalSheet({super.key});

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30)); // Default 1 month out
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.tealAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dto = CreateGoalDto(
        name: _nameController.text,
        targetAmount: double.parse(_amountController.text),
        deadline: _selectedDate,
      );

      final success = await ref.read(goalsControllerProvider.notifier).addGoal(dto);
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          context.pop(); // Close the bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal Created!'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create goal'), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // We wrap it in a Padding to handle the onscreen keyboard smoothly
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes only needed space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a New Goal",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),
            
            // GOAL NAME
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Goal Name', Icons.flag_outlined),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),

            // TARGET AMOUNT
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Target Amount', Icons.attach_money).copyWith(
                prefixText: '\$ ',
                prefixStyle: const TextStyle(color: Colors.tealAccent, fontSize: 16),
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter an amount' : null,
            ),
            const SizedBox(height: 16),

            // DEADLINE PICKER
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: _buildInputDecoration('Target Date', Icons.calendar_today_outlined),
                child: Text(
                  DateFormat('MMMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("START SAVING", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Colors.tealAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.tealAccent)),
    );
  }
}