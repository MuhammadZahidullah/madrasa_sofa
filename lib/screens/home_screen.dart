import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/providers/teacher_provider.dart';
import 'package:madrasa_soffa/screens/attendance/mark_attendance_screen.dart';
import 'package:madrasa_soffa/screens/class/class_list_screen.dart';
import 'package:madrasa_soffa/screens/fees/fee_list_screen.dart';
import 'package:madrasa_soffa/screens/lessons/lesson_progress_screen.dart';
import 'package:madrasa_soffa/screens/student/student_list_screen.dart';
import 'package:madrasa_soffa/screens/teacher/teacher_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final teacherProvider = Provider.of<TeacherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Madrasa Management')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _buildDashboardCard(
              context,
              'Students',
              studentProvider.students.length.toString(),
              Icons.people,
              StudentListScreen(),
            ),
            _buildDashboardCard(
              context,
              'Classes',
              classProvider.classes.length.toString(),
              Icons.class_,
              ClassListScreen(),
            ),
            _buildDashboardCard(
              context,
              'Teachers',
              teacherProvider.teachers.length.toString(),
              Icons.person,
              TeacherListScreen(),
            ),
            _buildDashboardCard(
              context,
              'Mark Attendance',
              '',
              Icons.check_circle,
              MarkAttendanceScreen(),
            ),
            _buildDashboardCard(
              context,
              'Lesson Progress',
              '',
              Icons.show_chart,
              LessonProgressScreen(),
            ),
            _buildDashboardCard(
              context,
              'Fee Payments',
              '',
              Icons.payment,
              FeeListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              if (value.isNotEmpty) SizedBox(height: 5),
              if (value.isNotEmpty) Text(value, style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
