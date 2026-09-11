import 'package:flutter/material.dart';
import 'package:madrasa_soffa/l10n/app_localizations.dart';
import 'package:madrasa_soffa/core/localization/locale_provider.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          DropdownButton<String>(
            value: localeProvider.locale.languageCode,
            icon: const Icon(Icons.language, color: Colors.white),
            dropdownColor: Theme.of(context).primaryColor,
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                localeProvider.setLocale(Locale(newValue));
              }
            },
            items: <String>['en', 'ur', 'ar']
                .map<DropdownMenuItem<String>>((String value) {
              String label = '';
              if (value == 'en') label = l10n.english;
              if (value == 'ur') label = l10n.urdu;
              if (value == 'ar') label = l10n.arabic;
              return DropdownMenuItem<String>(
                value: value,
                child: Text(label, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _buildDashboardCard(
              context,
              l10n.students,
              studentProvider.students.length.toString(),
              Icons.people,
              const StudentListScreen(),
            ),
            _buildDashboardCard(
              context,
              l10n.classes,
              classProvider.classes.length.toString(),
              Icons.class_,
              const ClassListScreen(),
            ),
            _buildDashboardCard(
              context,
              l10n.teachers,
              teacherProvider.teachers.length.toString(),
              Icons.person,
              const TeacherListScreen(),
            ),
            _buildDashboardCard(
              context,
              l10n.attendance,
              '',
              Icons.check_circle,
              const MarkAttendanceScreen(),
            ),
            _buildDashboardCard(
              context,
              l10n.results, // Replaced "Lesson Progress" with "Results" for now or use "books"
              '',
              Icons.show_chart,
              const LessonProgressScreen(),
            ),
            _buildDashboardCard(
              context,
              l10n.fees,
              '',
              Icons.payment,
              const FeeListScreen(),
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
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (value.isNotEmpty) const SizedBox(height: 5),
              if (value.isNotEmpty) Text(value, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
