import '../entities/teaching_assignment.dart';

abstract class TeachingAssignmentRepository {
  Future<List<TeachingAssignment>> getAssignmentsByTeacher(String teacherId);
  Future<void> saveTeacherAssignments(String teacherId, List<TeachingAssignment> assignments);
  Future<void> deleteAssignmentsByTeacher(String teacherId);
}
