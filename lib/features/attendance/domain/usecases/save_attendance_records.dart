import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class SaveAttendanceRecords {
  final AttendanceRepository repository;

  SaveAttendanceRecords(this.repository);

  Future<bool> execute(List<Attendance> records) {
    return repository.saveAttendanceRecords(records);
  }
}
