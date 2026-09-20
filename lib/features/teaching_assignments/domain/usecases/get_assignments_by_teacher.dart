import '../entities/teaching_assignment.dart';
import '../repositories/teaching_assignment_repository.dart';

class GetAssignmentsByTeacher {
  final TeachingAssignmentRepository repository;

  GetAssignmentsByTeacher(this.repository);

  Future<List<TeachingAssignment>> execute(String teacherId) {
    return repository.getAssignmentsByTeacher(teacherId);
  }
}
