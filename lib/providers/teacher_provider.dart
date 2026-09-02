import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/teacher.dart';
import 'package:madrasa_soffa/repositories/teacher_repository.dart';

class TeacherProvider with ChangeNotifier {
  final TeacherRepository _teacherRepository = TeacherRepository();
  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  Future<void> loadTeachers() async {
    _teachers = await _teacherRepository.getTeachers();
    notifyListeners();
  }

  Future<void> addTeacher(Teacher teacher) async {
    await _teacherRepository.addTeacher(teacher);
    await loadTeachers();
  }

  Future<void> updateTeacher(Teacher teacher) async {
    await _teacherRepository.updateTeacher(teacher);
    await loadTeachers();
  }

  Future<void> deleteTeacher(int id) async {
    await _teacherRepository.deleteTeacher(id);
    await loadTeachers();
  }
}
