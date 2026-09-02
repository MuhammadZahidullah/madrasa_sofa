import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/lesson_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/screens/lessons/add_edit_lesson_screen.dart';
import 'package:provider/provider.dart';

class LessonProgressScreen extends StatelessWidget {
  const LessonProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Progress'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditLessonScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer2<LessonProvider, StudentProvider>(
        builder: (context, lessonProvider, studentProvider, child) {
          if (studentProvider.students.isEmpty) {
            return Center(child: Text('No students available.'));
          }
          return ListView.builder(
            itemCount: studentProvider.students.length,
            itemBuilder: (context, index) {
              final student = studentProvider.students[index];
              final studentLessons = lessonProvider.lessons
                  .where((l) => l.studentId == student.id)
                  .toList();
              return ExpansionTile(
                title: Text(student.name),
                children: studentLessons.isNotEmpty
                    ? studentLessons.map((lesson) {
                        return ListTile(
                          title: Text(lesson.subject),
                          subtitle: LinearProgressIndicator(
                            value: lesson.progress / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                          trailing: Text(
                            '${lesson.progress.toStringAsFixed(0)}%',
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddEditLessonScreen(
                                student: student,
                                lesson: lesson,
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : [
                        ListTile(
                          title: Text('No lessons tracked for this student.'),
                        ),
                      ],
              );
            },
          );
        },
      ),
    );
  }
}
