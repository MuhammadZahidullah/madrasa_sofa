import '../repositories/teaching_assignment_repository.dart';

class DeleteAssignmentsByTeacher {
  final TeachingAssignmentRepository repository;

  DeleteAssignmentsByTeacher(this.repository);

  Future<void> execute(String teacherId) {
    return repository.deleteAssignmentsByTeacher(teacherId);
  }
}
