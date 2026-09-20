import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

class GetTeachers {
  final TeacherRepository repository;

  GetTeachers(this.repository);

  Future<List<Teacher>> execute() async {
    return await repository.getTeachers();
  }
}
