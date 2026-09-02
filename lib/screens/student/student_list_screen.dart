import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/screens/student/add_edit_student_screen.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditStudentScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.students.isEmpty) {
            return Center(child: Text('No students added yet.'));
          }
          return ListView.builder(
            itemCount: provider.students.length,
            itemBuilder: (context, index) {
              final student = provider.students[index];
              return ListTile(
                title: Text(student.name),
                subtitle: Text(student.className),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditStudentScreen(student: student),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<StudentProvider>(
                          context,
                          listen: false,
                        ).deleteStudent(student.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
