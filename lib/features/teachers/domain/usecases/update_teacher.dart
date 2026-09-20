import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

class UpdateTeacher {
  final TeacherRepository repository;

  UpdateTeacher(this.repository);

  Future<void> execute(Teacher teacher) async {
    return await repository.updateTeacher(teacher);
  }
}
