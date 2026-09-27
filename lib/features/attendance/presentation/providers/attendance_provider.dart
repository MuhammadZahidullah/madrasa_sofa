import 'package:flutter/material.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/get_attendance_for_class_and_date.dart';
import '../../domain/usecases/save_attendance_records.dart';
import '../../../students/domain/entities/student.dart';
import '../../../students/domain/usecases/get_students_by_class_id.dart';
import '../../../teaching_assignments/domain/usecases/get_assignments_by_teacher.dart';

class AttendanceProvider extends ChangeNotifier {
  final GetAssignmentsByTeacher _getAssignmentsByTeacher;
  final GetStudentsByClassId _getStudentsByClassId;
  final GetAttendanceForClassAndDate _getAttendanceForClassAndDate;
  final SaveAttendanceRecords _saveAttendanceRecords;

  AttendanceProvider({
    required GetAssignmentsByTeacher getAssignmentsByTeacher,
    required GetStudentsByClassId getStudentsByClassId,
    required GetAttendanceForClassAndDate getAttendanceForClassAndDate,
    required SaveAttendanceRecords saveAttendanceRecords,
  })  : _getAssignmentsByTeacher = getAssignmentsByTeacher,
        _getStudentsByClassId = getStudentsByClassId,
        _getAttendanceForClassAndDate = getAttendanceForClassAndDate,
        _saveAttendanceRecords = saveAttendanceRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _error;
  String? get error => _error;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  List<String> _authorizedClassIds = [];
  List<String> get authorizedClassIds => _authorizedClassIds;

  String? _selectedClassId;
  String? get selectedClassId => _selectedClassId;

  String _currentDateKey = _getTodayDateKey();
  String get currentDateKey => _currentDateKey;

  List<Student> _students = [];
  List<Student> get students => _students;

  // Maps studentId to the selected status (null means unmarked)
  Map<String, AttendanceStatus?> _attendanceState = {};
  Map<String, AttendanceStatus?> get attendanceState => _attendanceState;

  // Stores originally loaded attendance records to preserve createdAt and ID
  Map<String, Attendance> _existingRecords = {};

  static String _getTodayDateKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> initForTeacher(String teacherId) async {
    if (teacherId.isEmpty) {
      _error = 'Teacher ID cannot be empty';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignments = await _getAssignmentsByTeacher.execute(teacherId);
      // Deduplicate active assignments by classId
      _authorizedClassIds = assignments
          .where((a) => a.isActive)
          .map((a) => a.classId)
          .toSet()
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectClass(String classId, [String? dateKey]) async {
    _selectedClassId = classId;
    if (dateKey != null) {
      _currentDateKey = dateKey;
    }

    _isLoading = true;
    _hasLoaded = false;
    _error = null;
    notifyListeners();

    try {
      // Load all students for the specific class and filter by active status
      final classStudents = await _getStudentsByClassId.execute(classId);
      _students = classStudents.where((s) => s.isActive).toList();

      // Load existing attendance for class and date
      final attendanceRecords = await _getAttendanceForClassAndDate.execute(classId, _currentDateKey);
      
      _existingRecords = {
        for (var record in attendanceRecords) record.studentId: record
      };

      // Initialize state for each student
      _attendanceState = {};
      for (var student in _students) {
        if (_existingRecords.containsKey(student.id)) {
          _attendanceState[student.id] = _existingRecords[student.id]!.status;
        } else {
          _attendanceState[student.id] = null; // Unmarked
        }
      }

      _hasLoaded = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStudentStatus(String studentId, AttendanceStatus status) {
    if (_attendanceState.containsKey(studentId)) {
      _attendanceState[studentId] = status;
      notifyListeners();
    }
  }

  Future<bool> saveAttendance(String teacherId) async {
    if (_selectedClassId == null) {
      _error = 'No class selected';
      notifyListeners();
      return false;
    }

    if (teacherId.isEmpty) {
      _error = 'Teacher ID is required to save attendance';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      List<Attendance> recordsToSave = [];
      final now = DateTime.now();

      _attendanceState.forEach((studentId, status) {
        if (status != null) {
          if (_existingRecords.containsKey(studentId)) {
            final existing = _existingRecords[studentId]!;
            recordsToSave.add(existing.copyWith(
              teacherId: teacherId,
              status: status,
              // Keep original createdAt, but update updatedAt
              updatedAt: now,
            ));
          } else {
            // New record
            recordsToSave.add(Attendance(
              id: Attendance.generateId(
                classId: _selectedClassId!,
                studentId: studentId,
                dateKey: _currentDateKey,
              ),
              studentId: studentId,
              classId: _selectedClassId!,
              teacherId: teacherId,
              dateKey: _currentDateKey,
              status: status,
              createdAt: now,
              updatedAt: now,
            ));
          }
        }
      });

      if (recordsToSave.isNotEmpty) {
        await _saveAttendanceRecords.execute(recordsToSave);
        
        // Update existing records so subsequent saves in the same session don't overwrite createdAt
        for (var record in recordsToSave) {
          _existingRecords[record.studentId] = record;
        }
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
