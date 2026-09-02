import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/teacher_provider.dart';
import 'package:madrasa_soffa/screens/teacher/add_edit_teacher_screen.dart';
import 'package:provider/provider.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditTeacherScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TeacherProvider>(
        builder: (context, provider, child) {
          if (provider.teachers.isEmpty) {
            return Center(child: Text('No teachers added yet.'));
          }
          return ListView.builder(
            itemCount: provider.teachers.length,
            itemBuilder: (context, index) {
              final teacher = provider.teachers[index];
              return ListTile(
                title: Text(teacher.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditTeacherScreen(teacher: teacher),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<TeacherProvider>(
                          context,
                          listen: false,
                        ).deleteTeacher(teacher.id!);
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
