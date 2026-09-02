import 'package:flutter/material.dart';
import 'package:madrasa_soffa/providers/class_provider.dart';
import 'package:madrasa_soffa/screens/class/add_edit_class_screen.dart';
import 'package:provider/provider.dart';

class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditClassScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ClassProvider>(
        builder: (context, provider, child) {
          if (provider.classes.isEmpty) {
            return Center(child: Text('No classes added yet.'));
          }
          return ListView.builder(
            itemCount: provider.classes.length,
            itemBuilder: (context, index) {
              final classModel = provider.classes[index];
              return ListTile(
                title: Text(classModel.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditClassScreen(classModel: classModel),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<ClassProvider>(
                          context,
                          listen: false,
                        ).deleteClass(classModel.id!);
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
