import '../repositories/teacher_repository.dart';
import '../../../teaching_assignments/domain/repositories/teaching_assignment_repository.dart';

class DeleteTeacher {
  final TeacherRepository teacherRepository;
  final TeachingAssignmentRepository assignmentRepository;

  DeleteTeacher(this.teacherRepository, this.assignmentRepository);

  Future<void> execute(String id) async {
    // 1. Delete all teaching assignments for this teacher
    await assignmentRepository.deleteAssignmentsByTeacher(id);
    
    // 2. Delete the teacher profile
    await teacherRepository.deleteTeacher(id);
  }
}
