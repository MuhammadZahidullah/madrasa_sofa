import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

class AddTeacher {
  final TeacherRepository repository;

  AddTeacher(this.repository);

  Future<void> execute(Teacher teacher) async {
    return await repository.addTeacher(teacher);
  }
}
