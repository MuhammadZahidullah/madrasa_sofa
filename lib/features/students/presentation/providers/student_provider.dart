import 'package:flutter/material.dart';
import '../../domain/entities/student.dart';
import '../../domain/usecases/get_students.dart';
import '../../domain/usecases/add_student.dart';
import '../../domain/usecases/update_student.dart';
import '../../domain/usecases/delete_student.dart';

class StudentProvider extends ChangeNotifier {
  final GetStudents _getStudents;
  final AddStudent _addStudent;
  final UpdateStudent _updateStudent;
  final DeleteStudent _deleteStudent;

  StudentProvider({
    required GetStudents getStudents,
    required AddStudent addStudent,
    required UpdateStudent updateStudent,
    required DeleteStudent deleteStudent,
  }) : _getStudents = getStudents,
       _addStudent = addStudent,
       _updateStudent = updateStudent,
       _deleteStudent = deleteStudent;

  List<Student> _students = [];
  List<Student> get students => _students;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchStudents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _students = List<Student>.from(await _getStudents.execute());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStudent(Student student) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addStudent.execute(student);
      _students = List<Student>.from(await _getStudents.execute());
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStudent(Student student) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _updateStudent.execute(student);
      final index = _students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        final updatedList = List<Student>.from(_students);
        updatedList[index] = student;
        _students = updatedList;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteStudent(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteStudent.execute(id);
      _students.removeWhere((s) => s.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
