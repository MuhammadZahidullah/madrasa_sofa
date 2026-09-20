import '../entities/teaching_assignment.dart';
import '../repositories/teaching_assignment_repository.dart';

class SaveTeacherAssignments {
  final TeachingAssignmentRepository repository;

  SaveTeacherAssignments(this.repository);

  Future<void> execute(String teacherId, List<TeachingAssignment> assignments) {
    return repository.saveTeacherAssignments(teacherId, assignments);
  }
}
