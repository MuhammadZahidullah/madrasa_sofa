import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/lesson.dart';
import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/providers/lesson_provider.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:provider/provider.dart';

class AddEditLessonScreen extends StatefulWidget {
  final Student? student;
  final Lesson? lesson;

  const AddEditLessonScreen({super.key, this.student, this.lesson});

  @override
  _AddEditLessonScreenState createState() => _AddEditLessonScreenState();
}

class _AddEditLessonScreenState extends State<AddEditLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  Student? _selectedStudent;
  String? _subject;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _selectedStudent = widget.student;
    if (widget.lesson != null) {
      _subject = widget.lesson!.subject;
      _progress = widget.lesson!.progress;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedStudent != null && _subject != null) {
        final lessonProvider = Provider.of<LessonProvider>(
          context,
          listen: false,
        );
        final newLesson = Lesson(
          id: widget.lesson?.id,
          studentId: _selectedStudent!.id!,
          subject: _subject!,
          progress: _progress,
        );
        lessonProvider.addOrUpdateLesson(newLesson);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson == null
              ? 'Add Lesson Progress'
              : 'Edit Lesson Progress',
        ),
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
                initialValue: _subject,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value;
                },
              ),
              SizedBox(height: 20),
              Text('Progress: ${_progress.toInt()}%'),
              Slider(
                value: _progress,
                min: 0,
                max: 100,
                divisions: 100,
                label: _progress.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _progress = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
