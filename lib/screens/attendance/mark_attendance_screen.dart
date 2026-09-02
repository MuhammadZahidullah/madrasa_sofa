import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madrasa_soffa/models/attendance.dart';
import 'package:madrasa_soffa/models/class.dart' as models;
import 'package:madrasa_soffa/providers/attendance_provider.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:provider/provider.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  _MarkAttendanceScreenState createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  models.Class? _selectedClass;
  DateTime _selectedDate = DateTime.now();
  final Map<int, bool> _attendanceStatus = {};

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);

    final filteredStudents = studentProvider.students
        .where((s) => s.className == _selectedClass?.name)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Mark Attendance')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<models.Class>(
                    hint: Text('Select Class'),
                    value: _selectedClass,
                    items: classProvider.classes.map((models.Class c) {
                      return DropdownMenuItem<models.Class>(
                        value: c,
                        child: Text(c.name),
                      );
                    }).toList(),
                    onChanged: (models.Class? newValue) {
                      setState(() {
                        _selectedClass = newValue;
                        _attendanceStatus.clear();
                        if (newValue != null) {
                          final studentsInClass = studentProvider.students
                              .where((s) => s.className == newValue.name)
                              .toList();
                          for (var student in studentsInClass) {
                            _attendanceStatus[student.id!] =
                                true; // Default to present
                          }
                        }
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                IconButton(
                  icon: Icon(Icons.calendar_today),
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
          ),
          Expanded(
            child: _selectedClass == null
                ? Center(child: Text('Please select a class.'))
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return CheckboxListTile(
                        title: Text(student.name),
                        value: _attendanceStatus[student.id!] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _attendanceStatus[student.id!] = value!;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_selectedClass != null) {
            final attendanceProvider = Provider.of<AttendanceProvider>(
              context,
              listen: false,
            );
            _attendanceStatus.forEach((studentId, isPresent) {
              final attendance = Attendance(
                studentId: studentId,
                classId: _selectedClass!.id!,
                date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                isPresent: isPresent,
              );
              attendanceProvider.addAttendance(attendance);
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Attendance saved!')));
          }
        },
      ),
    );
  }
}
