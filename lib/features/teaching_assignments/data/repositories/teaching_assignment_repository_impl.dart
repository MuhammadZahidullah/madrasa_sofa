import '../../domain/entities/teaching_assignment.dart';
import '../../domain/repositories/teaching_assignment_repository.dart';
import '../datasources/teaching_assignment_remote_data_source.dart';
import '../models/teaching_assignment_model.dart';

class TeachingAssignmentRepositoryImpl implements TeachingAssignmentRepository {
  final TeachingAssignmentRemoteDataSource remoteDataSource;

  TeachingAssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TeachingAssignment>> getAssignmentsByTeacher(String teacherId) async {
    return await remoteDataSource.getAssignmentsByTeacher(teacherId);
  }

  @override
  Future<void> saveTeacherAssignments(String teacherId, List<TeachingAssignment> assignments) async {
    final models = assignments.map((a) => TeachingAssignmentModel.fromEntity(a)).toList();
    await remoteDataSource.saveTeacherAssignments(teacherId, models);
  }

  @override
  Future<void> deleteAssignmentsByTeacher(String teacherId) async {
    await remoteDataSource.deleteAssignmentsByTeacher(teacherId);
  }
}
