import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/attendance_provider.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/providers/fee_provider.dart';
import 'package:madrasa_soffa/providers/lesson_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:madrasa_soffa/providers/teacher_provider.dart';
import 'package:madrasa_soffa/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StudentProvider()..loadStudents(),
        ),
        ChangeNotifierProvider(create: (_) => ClassProvider()..loadClasses()),
        ChangeNotifierProvider(
          create: (_) => TeacherProvider()..loadTeachers(),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider()..loadAttendance(),
        ),
        ChangeNotifierProvider(create: (_) => FeeProvider()..loadFees()),
        ChangeNotifierProvider(create: (_) => LessonProvider()..loadLessons()),
      ],
      child: MaterialApp(
        title: 'Madrasa Soffa',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
