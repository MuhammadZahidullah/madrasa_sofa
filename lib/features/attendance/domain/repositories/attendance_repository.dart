import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendanceForClassAndDate(String classId, String dateKey);
  
  Future<List<Attendance>> getAttendanceForStudent(String studentId);
  
  Future<bool> saveAttendanceRecords(List<Attendance> records);
}
