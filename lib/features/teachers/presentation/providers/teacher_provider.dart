import 'package:flutter/material.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/usecases/get_teachers.dart';
import '../../domain/usecases/add_teacher.dart';
import '../../domain/usecases/update_teacher.dart';
import '../../domain/usecases/delete_teacher.dart';

class TeacherProvider extends ChangeNotifier {
  final GetTeachers _getTeachers;
  final AddTeacher _addTeacher;
  final UpdateTeacher _updateTeacher;
  final DeleteTeacher _deleteTeacher;

  TeacherProvider({
    required GetTeachers getTeachers,
    required AddTeacher addTeacher,
    required UpdateTeacher updateTeacher,
    required DeleteTeacher deleteTeacher,
  }) : _getTeachers = getTeachers,
       _addTeacher = addTeacher,
       _updateTeacher = updateTeacher,
       _deleteTeacher = deleteTeacher;

  List<Teacher> _teachers = [];
  List<Teacher> get teachers => _teachers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchTeachers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _teachers = List<Teacher>.from(await _getTeachers.execute());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTeacher(Teacher teacher) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addTeacher.execute(teacher);
      _teachers = List<Teacher>.from(await _getTeachers.execute());
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTeacher(Teacher teacher) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _updateTeacher.execute(teacher);
      final index = _teachers.indexWhere((t) => t.id == teacher.id);
      if (index != -1) {
        final updatedList = List<Teacher>.from(_teachers);
        updatedList[index] = teacher;
        _teachers = updatedList;
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

  Future<bool> deleteTeacher(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteTeacher.execute(id);
      _teachers.removeWhere((t) => t.id == id);
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
