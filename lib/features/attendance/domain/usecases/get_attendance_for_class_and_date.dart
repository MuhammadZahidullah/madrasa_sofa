import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceForClassAndDate {
  final AttendanceRepository repository;

  GetAttendanceForClassAndDate(this.repository);

  Future<List<Attendance>> execute(String classId, String dateKey) {
    return repository.getAttendanceForClassAndDate(classId, dateKey);
  }
}
