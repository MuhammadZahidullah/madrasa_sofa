import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/class.dart' as models;
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:provider/provider.dart';

class AddEditClassScreen extends StatefulWidget {
  final models.Class? classModel;

  const AddEditClassScreen({super.key, this.classModel});

  @override
  _AddEditClassScreenState createState() => _AddEditClassScreenState();
}

class _AddEditClassScreenState extends State<AddEditClassScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.classModel?.name ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final classProvider = Provider.of<ClassProvider>(context, listen: false);
      if (widget.classModel == null) {
        classProvider.addClass(models.Class(name: _name));
      } else {
        classProvider.updateClass(
          models.Class(id: widget.classModel!.id, name: _name),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classModel == null ? 'Add Class' : 'Edit Class'),
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
                decoration: InputDecoration(labelText: 'Class Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a class name.';
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
