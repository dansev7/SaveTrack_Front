import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'transaction_models.dart';
import 'transaction_provider.dart';
import '../dashboard/dashboard_models.dart'; 

class AddTransactionSheet extends ConsumerStatefulWidget {
  final Transaction? existingTransaction;

  const AddTransactionSheet({super.key, this.existingTransaction});

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  
  late int _selectedType;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final isEdit = widget.existingTransaction != null;
    _amountController = TextEditingController(text: isEdit ? widget.existingTransaction!.amount.toString() : '');
    _descriptionController = TextEditingController(text: isEdit ? widget.existingTransaction!.description : '');
    _selectedType = isEdit ? widget.existingTransaction!.type : 1;
    _selectedDate = isEdit ? widget.existingTransaction!.date : DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2101),
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
      final dto = CreateTransactionDto(
        amount: double.parse(_amountController.text),
        type: _selectedType,
        description: _descriptionController.text,
        date: _selectedDate,
      );

      final notifier = ref.read(createTransactionControllerProvider.notifier);
      final bool success;

      if (widget.existingTransaction != null) {
        success = await notifier.updateTransaction(widget.existingTransaction!.id, dto);
      } else {
        success = await notifier.submitTransaction(dto);
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.existingTransaction != null ? 'Transaction Updated!' : 'Transaction Saved!'), backgroundColor: Colors.green),
        );
        context.pop(); // Close the sheet
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(createTransactionControllerProvider);
    final isEdit = widget.existingTransaction != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Prevent keyboard from hiding fields
        left: 24, right: 24, top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? "Edit Transaction" : "New Transaction",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // AMOUNT
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Amount', Icons.attach_money).copyWith(
                prefixText: '\$ ', prefixStyle: const TextStyle(color: Colors.tealAccent, fontSize: 16),
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter an amount' : null,
            ),
            const SizedBox(height: 16),

            // DESCRIPTION
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration('Description', Icons.description_outlined),
              validator: (val) => (val == null || val.isEmpty) ? 'Enter a description' : null,
            ),
            const SizedBox(height: 16),

            // TYPE DROPDOWN
            DropdownButtonFormField<int>(
              initialValue: _selectedType,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: _buildInputDecoration('Type', Icons.category_outlined),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Income (+)')),
                DropdownMenuItem(value: 1, child: Text('Expense (-)')),
                DropdownMenuItem(value: 2, child: Text('Saving')),
              ],
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            const SizedBox(height: 16),

            // DATE
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: _buildInputDecoration('Date', Icons.calendar_today_outlined),
                child: Text(DateFormat('MMMM dd, yyyy').format(_selectedDate), style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),

            // ERROR & SUBMIT
            if (controllerState.hasError) ...[
              Text(controllerState.error.toString(), style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controllerState.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: controllerState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? "UPDATE" : "SAVE", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label, labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Colors.tealAccent),
      filled: true, fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.tealAccent)),
    );
  }
}