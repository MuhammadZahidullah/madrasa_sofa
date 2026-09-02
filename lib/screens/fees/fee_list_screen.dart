import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/providers/fee_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/screens/fees/add_fee_screen.dart';
import 'package:provider/provider.dart';

class FeeListScreen extends StatelessWidget {
  const FeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fee Payments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AddFeeScreen()));
            },
          ),
        ],
      ),
      body: Consumer2<FeeProvider, StudentProvider>(
        builder: (context, feeProvider, studentProvider, child) {
          if (feeProvider.fees.isEmpty) {
            return Center(child: Text('No fee payments recorded yet.'));
          }
          return ListView.builder(
            itemCount: feeProvider.fees.length,
            itemBuilder: (context, index) {
              final fee = feeProvider.fees[index];
              Student? student;
              try {
                student = studentProvider.students.firstWhere(
                  (s) => s.id == fee.studentId,
                );
              } catch (e) {
                // Student might have been deleted, so we handle the error.
                student = null;
              }
              return ListTile(
                title: Text('Student: ${student?.name ?? 'Unknown'}'),
                subtitle: Text(
                  'Amount: \$${fee.amount.toStringAsFixed(2)} on ${fee.date}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
