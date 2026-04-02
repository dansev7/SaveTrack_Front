import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'goal_models.dart';
import 'goals_provider.dart';

class AddGoalSheet extends ConsumerStatefulWidget {
  final Goal? existingGoal; // 👈 Accept an optional goal

  const AddGoalSheet({super.key, this.existingGoal});

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 👈 Pre-fill data if we are editing!
    final isEdit = widget.existingGoal != null;
    _nameController = TextEditingController(text: isEdit ? widget.existingGoal!.name : '');
    _amountController = TextEditingController(text: isEdit ? widget.existingGoal!.targetAmount.toString() : '');
    _selectedDate = isEdit ? widget.existingGoal!.deadline : DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: Colors.tealAccent, onPrimary: Colors.black, surface: Color(0xFF1E1E1E)),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) setState(() => _selectedDate = picked);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dto = CreateGoalDto(
        name: _nameController.text,
        targetAmount: double.parse(_amountController.text),
        deadline: _selectedDate,
      );

      final notifier = ref.read(goalsControllerProvider.notifier);
      final bool success;

      // 👈 Branch logic based on Create vs Update
      if (widget.existingGoal != null) {
        success = await notifier.updateGoal(widget.existingGoal!.id, dto);
      } else {
        success = await notifier.addGoal(dto);
      }
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.existingGoal != null ? 'Goal Updated!' : 'Goal Created!'), 
              backgroundColor: Colors.green
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save goal'), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingGoal != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? "Edit Goal" : "Create a New Goal",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _nameController, style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Goal Name', Icons.flag_outlined),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Target Amount', Icons.attach_money).copyWith(
                prefixText: 'ETB ', prefixStyle: const TextStyle(color: Colors.tealAccent, fontSize: 16),
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter an amount' : null,
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: _buildInputDecoration('Target Date', Icons.calendar_today_outlined),
                child: Text(DateFormat('MMMM dd, yyyy').format(_selectedDate), style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700], foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? "UPDATE GOAL" : "START SAVING", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    // ... exactly the same helper method you had before
    return InputDecoration(
      labelText: label, labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Colors.tealAccent),
      filled: true, fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.tealAccent)),
    );
  }
}