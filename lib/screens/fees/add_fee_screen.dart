import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasa_soffa/models/fee.dart';
import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/providers/fee_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:provider/provider.dart';

class AddFeeScreen extends StatefulWidget {
  const AddFeeScreen({super.key});

  @override
  _AddFeeScreenState createState() => _AddFeeScreenState();
}

class _AddFeeScreenState extends State<AddFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  Student? _selectedStudent;
  double? _amount;
  DateTime _selectedDate = DateTime.now();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedStudent != null && _amount != null) {
        final feeProvider = Provider.of<FeeProvider>(context, listen: false);
        final newFee = Fee(
          studentId: _selectedStudent!.id!,
          amount: _amount!,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );
        feeProvider.addFee(newFee);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fee Payment'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Student>(
                initialValue: _selectedStudent,
                hint: Text('Select Student'),
                items: studentProvider.students.map((student) {
                  return DropdownMenuItem<Student>(
                    value: student,
                    child: Text(student.name),
                  );
                }).toList(),
                onChanged: (student) {
                  setState(() {
                    _selectedStudent = student;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a student' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    child: Text('Change Date'),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
