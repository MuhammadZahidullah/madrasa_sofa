import 'package:flutter/material.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_subjects.dart';
import '../../domain/usecases/add_subject.dart';
import '../../domain/usecases/update_subject.dart';
import '../../domain/usecases/delete_subject.dart';

class SubjectProvider extends ChangeNotifier {
  final GetSubjects _getSubjects;
  final AddSubject _addSubject;
  final UpdateSubject _updateSubject;
  final DeleteSubject _deleteSubject;

  SubjectProvider({
    required GetSubjects getSubjects,
    required AddSubject addSubject,
    required UpdateSubject updateSubject,
    required DeleteSubject deleteSubject,
  })  : _getSubjects = getSubjects,
        _addSubject = addSubject,
        _updateSubject = updateSubject,
        _deleteSubject = deleteSubject;

  List<Subject> _subjects = [];
  List<Subject> get subjects => _subjects;

  Subject? getSubjectById(String id) {
    try {
      return _subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _subjects = List<Subject>.from(await _getSubjects.execute());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSubject(Subject subject) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addSubject.execute(subject);
      _subjects = List<Subject>.from(await _getSubjects.execute());
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSubject(Subject subject) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _updateSubject.execute(subject);
      final index = _subjects.indexWhere((s) => s.id == subject.id);
      if (index != -1) {
        final updatedList = List<Subject>.from(_subjects);
        updatedList[index] = subject;
        _subjects = updatedList;
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

  Future<bool> deleteSubject(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteSubject.execute(id);
      _subjects.removeWhere((s) => s.id == id);
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
