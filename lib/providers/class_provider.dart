import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/class.dart' as models;
import 'package:madrasa_soffa/repositories/class_repository.dart';

class ClassProvider with ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();
  List<models.Class> _classes = [];

  List<models.Class> get classes => _classes;

  Future<void> loadClasses() async {
    _classes = await _classRepository.getClasses();
    notifyListeners();
  }

  Future<void> addClass(models.Class classModel) async {
    await _classRepository.addClass(classModel);
    await loadClasses();
  }

  Future<void> updateClass(models.Class classModel) async {
    await _classRepository.updateClass(classModel);
    await loadClasses();
  }

  Future<void> deleteClass(int id) async {
    await _classRepository.deleteClass(id);
    await loadClasses();
  }
}
