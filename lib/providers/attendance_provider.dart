import 'package:flutter/material.dart';
import 'package:madrasa_soffa/models/attendance.dart';
import 'package:madrasa_soffa/repositories/attendance_repository.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  List<Attendance> _attendanceList = [];

  List<Attendance> get attendanceList => _attendanceList;

  Future<void> loadAttendance() async {
    _attendanceList = await _attendanceRepository.getAllAttendance();
    notifyListeners();
  }

  Future<void> loadAttendanceByClass(int classId, String date) async {
    _attendanceList = await _attendanceRepository.getAttendanceByClass(
      classId,
      date,
    );
    notifyListeners();
  }

  Future<void> addAttendance(Attendance attendance) async {
    await _attendanceRepository.addAttendance(attendance);
    await loadAttendance();
  }
}
