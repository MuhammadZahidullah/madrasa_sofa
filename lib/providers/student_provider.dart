import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/student.dart';
import 'package:madrasa_soffa/repositories/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _studentRepository = StudentRepository();
  List<Student> _students = [];

  List<Student> get students => _students;

  Future<void> loadStudents() async {
    _students = await _studentRepository.getStudents();
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    await _studentRepository.addStudent(student);
    await loadStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _studentRepository.updateStudent(student);
    await loadStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _studentRepository.deleteStudent(id);
    await loadStudents();
  }
}
