import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceForStudent {
  final AttendanceRepository repository;

  GetAttendanceForStudent(this.repository);

  Future<List<Attendance>> execute(String studentId) {
    return repository.getAttendanceForStudent(studentId);
  }
}
