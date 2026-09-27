import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Attendance>> getAttendanceForClassAndDate(String classId, String dateKey) async {
    return await remoteDataSource.getAttendanceForClassAndDate(classId, dateKey);
  }

  @override
  Future<List<Attendance>> getAttendanceForStudent(String studentId) async {
    return await remoteDataSource.getAttendanceForStudent(studentId);
  }

  @override
  Future<bool> saveAttendanceRecords(List<Attendance> records) async {
    final models = records.map((r) => AttendanceModel.fromEntity(r)).toList();
    return await remoteDataSource.saveAttendanceRecords(models);
  }
}
