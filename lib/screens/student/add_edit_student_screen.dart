import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/providers/student_provider.dart';
import 'package:provider/provider.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  _AddEditStudentScreenState createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _className;

  @override
  void initState() {
    super.initState();
    _name = widget.student?.name ?? '';
    _className = widget.student?.className ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final studentProvider = Provider.of<StudentProvider>(
        context,
        listen: false,
      );
      if (widget.student == null) {
        studentProvider.addStudent(Student(name: _name, className: _className));
      } else {
        studentProvider.updateStudent(
          Student(id: widget.student!.id, name: _name, className: _className),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
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
              TextFormField(
                initialValue: _className,
                decoration: InputDecoration(labelText: 'Class'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a class.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _className = value!;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
