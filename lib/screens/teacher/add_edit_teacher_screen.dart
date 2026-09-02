import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/teacher.dart';
import 'package:madrasa_soffa/providers/teacher_provider.dart';
import 'package:provider/provider.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final Teacher? teacher;

  const AddEditTeacherScreen({super.key, this.teacher});

  @override
  _AddEditTeacherScreenState createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.teacher?.name ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final teacherProvider = Provider.of<TeacherProvider>(
        context,
        listen: false,
      );
      if (widget.teacher == null) {
        teacherProvider.addTeacher(Teacher(name: _name));
      } else {
        teacherProvider.updateTeacher(
          Teacher(id: widget.teacher!.id, name: _name),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? 'Add Teacher' : 'Edit Teacher'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
