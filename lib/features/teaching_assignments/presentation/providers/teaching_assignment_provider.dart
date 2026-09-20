import 'package:flutter/material.dart';
import '../../domain/entities/teaching_assignment.dart';
import '../../domain/usecases/get_assignments_by_teacher.dart';
import '../../domain/usecases/save_teacher_assignments.dart';

class TeachingAssignmentProvider extends ChangeNotifier {
  final GetAssignmentsByTeacher _getAssignmentsByTeacher;
  final SaveTeacherAssignments _saveTeacherAssignments;

  TeachingAssignmentProvider({
    required GetAssignmentsByTeacher getAssignmentsByTeacher,
    required SaveTeacherAssignments saveTeacherAssignments,
  })  : _getAssignmentsByTeacher = getAssignmentsByTeacher,
        _saveTeacherAssignments = saveTeacherAssignments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Holds assignments keyed by teacherId to avoid re-fetching constantly
  /// or wiping out data for other teachers when loading a specific one.
  final Map<String, List<TeachingAssignment>> _teacherAssignments = {};

  List<TeachingAssignment> getAssignmentsForTeacher(String teacherId) {
    return _teacherAssignments[teacherId] ?? [];
  }

  Future<void> fetchAssignmentsForTeacher(String teacherId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignments = await _getAssignmentsByTeacher.execute(teacherId);
      _teacherAssignments[teacherId] = assignments;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveAssignmentsForTeacher(String teacherId, List<TeachingAssignment> assignments) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _saveTeacherAssignments.execute(teacherId, assignments);
      _teacherAssignments[teacherId] = assignments;
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
