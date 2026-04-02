import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'transaction_models.dart';
import 'transaction_provider.dart';

class CreateTransactionScreen extends ConsumerStatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  ConsumerState<CreateTransactionScreen> createState() => _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends ConsumerState<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  int _selectedType = 1; // Default to Expense
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
      final dto = CreateTransactionDto(
        amount: double.parse(_amountController.text),
        type: _selectedType,
        description: _descriptionController.text,
        date: _selectedDate,
      );

      final success = await ref.read(createTransactionControllerProvider.notifier).submitTransaction(dto);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction Saved!'), backgroundColor: Colors.green),
        );
        context.pop(); // Go back to Dashboard
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(createTransactionControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('New Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AMOUNT
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(fontSize: 32, color: Colors.tealAccent),
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter an amount' : null,
              ),
              const SizedBox(height: 32),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Description', Icons.description_outlined),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 24),

              // TRANSACTION TYPE DROPDOWN
              DropdownButtonFormField<int>(
                value: _selectedType,
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
              const SizedBox(height: 24),

              // DATE PICKER
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: _buildInputDecoration('Date', Icons.calendar_today_outlined),
                  child: Text(
                    DateFormat('MMMM dd, yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ERROR MESSAGE
              if (controllerState.hasError) ...[
                Text(controllerState.error.toString(), style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 16),
              ],

              // SUBMIT BUTTON
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
                      : const Text("SAVE TRANSACTION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              )
            ],
          ),
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